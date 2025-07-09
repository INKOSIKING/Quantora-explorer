use tower::{Service, ServiceBuilder, Layer};
use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use std::time::{Instant, Duration};
use hyper::{Request, Response, Body};

pub struct RateLimiter {
    limits: Arc<Mutex<HashMap<String, (Instant, u32)>>>,
    max_requests: u32,
    window: Duration,
}

impl<S> Layer<S> for RateLimiter {
    type Service = RateLimitMiddleware<S>;

    fn layer(&self, service: S) -> Self::Service {
        RateLimitMiddleware {
            service,
            limits: self.limits.clone(),
            max_requests: self.max_requests,
            window: self.window,
        }
    }
}

pub struct RateLimitMiddleware<S> {
    service: S,
    limits: Arc<Mutex<HashMap<String, (Instant, u32)>>>,
    max_requests: u32,
    window: Duration,
}

impl<S, ReqBody> Service<Request<ReqBody>> for RateLimitMiddleware<S>
where
    S: Service<Request<ReqBody>, Response = Response<Body>>,
{
    type Response = Response<Body>;
    type Error = S::Error;
    type Future = S::Future;

    fn poll_ready(&mut self, cx: &mut std::task::Context) -> std::task::Poll<Result<(), Self::Error>> {
        self.service.poll_ready(cx)
    }

    fn call(&mut self, req: Request<ReqBody>) -> Self::Future {
        let ip = req
            .headers()
            .get("x-forwarded-for")
            .and_then(|h| h.to_str().ok())
            .unwrap_or("unknown")
            .to_string();

        let mut limits = self.limits.lock().unwrap();
        let entry = limits.entry(ip.clone()).or_insert((Instant::now(), 0));
        if entry.0.elapsed() > self.window {
            entry.0 = Instant::now();
            entry.1 = 0;
        }
        entry.1 += 1;
        if entry.1 > self.max_requests {
            // Return 429
            return Box::pin(async {
                Response::builder()
                    .status(429)
                    .body(Body::from("Too many requests"))
                    .unwrap()
            });
        }
        drop(limits);
        self.service.call(req)
    }
}