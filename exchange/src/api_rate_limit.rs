use std::collections::HashMap;
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};
use actix_web::{dev::ServiceRequest, Error};
use actix_web_lab::middleware::from_fn;

pub struct RateLimiter {
    pub limits: Arc<Mutex<HashMap<String, (Instant, u32)>>>,
    pub max_requests: u32,
    pub window: Duration,
}

impl RateLimiter {
    pub fn new(max_requests: u32, window: Duration) -> Self {
        Self {
            limits: Arc::new(Mutex::new(HashMap::new())),
            max_requests,
            window,
        }
    }
}

pub async fn rate_limit_middleware(
    req: ServiceRequest,
    limiter: Arc<RateLimiter>,
) -> Result<ServiceRequest, Error> {
    let ip = req
        .connection_info()
        .realip_remote_addr()
        .unwrap_or("unknown")
        .to_string();
    let mut limits = limiter.limits.lock().unwrap();
    let entry = limits.entry(ip.clone()).or_insert((Instant::now(), 0));
    if entry.0.elapsed() > limiter.window {
        entry.0 = Instant::now();
        entry.1 = 0;
    }
    entry.1 += 1;
    if entry.1 > limiter.max_requests {
        return Err(actix_web::error::ErrorTooManyRequests("Too many requests"));
    }
    drop(limits);
    Ok(req)
}