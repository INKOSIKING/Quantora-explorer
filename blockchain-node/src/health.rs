
use warp::Filter;
use serde_json::json;

pub fn health_routes() -> impl Filter<Extract = impl warp::Reply, Error = warp::Rejection> + Clone {
    warp::path("health")
        .and(warp::get())
        .map(|| {
            warp::reply::json(&json!({
                "status": "healthy",
                "service": "quantora-blockchain",
                "timestamp": chrono::Utc::now().to_rfc3339(),
                "version": env!("CARGO_PKG_VERSION")
            }))
        })
}

pub fn metrics_routes() -> impl Filter<Extract = impl warp::Reply, Error = warp::Rejection> + Clone {
    warp::path("metrics")
        .and(warp::get())
        .map(|| {
            warp::reply::json(&json!({
                "blocks_processed": 0,
                "active_connections": 1,
                "uptime_seconds": 0
            }))
        })
}
