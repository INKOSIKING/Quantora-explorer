mod health;
// ... in HttpServer::new closure:
.route("/healthz", web::get().to(health::liveness))
.route("/readyz", web::get().to(health::readiness))