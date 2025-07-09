use axum::{Router, routing::get, extract::Path, http::StatusCode, Json};
use serde::Serialize;

#[derive(Serialize)]
struct BlockResponse { number: u64, hash: String, timestamp: u64 }

async fn get_block(Path(number): Path<u64>) -> Result<Json<BlockResponse>, StatusCode> {
    // Query block from DB or node RPC
    Ok(Json(BlockResponse {
        number,
        hash: "0x123...".to_string(),
        timestamp: 1620000000
    }))
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/block/:number", get(get_block));
    axum::Server::bind(&"0.0.0.0:8080".parse().unwrap())
        .serve(app.into_make_service()).await.unwrap();
}