use actix_cors::Cors;
use actix_web::{middleware::Logger, web, App, HttpResponse, HttpServer};
use dotenvy::dotenv;
use indexer::sync::sync_blocks_and_txs;
use indexer::{IndexerApi, StatsApi};
use sqlx::postgres::PgPoolOptions;
use std::env;
use std::sync::Arc;
use tokio::time::{sleep, Duration};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    env_logger::init();

    let db_url = env::var("INDEXER_DATABASE_URL").expect("INDEXER_DATABASE_URL must be set");
    let blockchain_api_url =
        env::var("BLOCKCHAIN_API_URL").expect("BLOCKCHAIN_API_URL must be set");
    let host = env::var("INDEXER_HOST").unwrap_or_else(|_| "0.0.0.0".to_string());
    let port = env::var("INDEXER_PORT")
        .ok()
        .and_then(|p| p.parse().ok())
        .unwrap_or(8003);

    let pool = Arc::new(
        PgPoolOptions::new()
            .max_connections(5)
            .connect(&db_url)
            .await
            .expect("Failed to connect to DB"),
    );

    // Spawn periodic sync task
    let pool2 = pool.clone();
    let blockchain_api_url2 = blockchain_api_url.clone();
    tokio::spawn(async move {
        loop {
            if let Err(e) = sync_blocks_and_txs(pool2.clone(), blockchain_api_url2.clone()).await {
                eprintln!("Indexer sync error: {:?}", e);
            }
            sleep(Duration::from_secs(10)).await;
        }
    });

    HttpServer::new(move || {
        let cors = Cors::permissive();
        App::new()
            .wrap(Logger::default())
            .wrap(cors)
            .app_data(web::Data::from(pool.clone()))
            .route("/block/{hash}", web::get().to(IndexerApi::get_block))
            .route("/tx/{tx_id}", web::get().to(IndexerApi::get_tx))
            .route("/blocks/recent", web::get().to(IndexerApi::recent_blocks))
            .route("/txs/recent", web::get().to(IndexerApi::recent_txs))
            .route("/stats", web::get().to(StatsApi::stats))
            .default_service(web::route().to(|| HttpResponse::NotFound().body("Route not found")))
    })
    .bind((host.as_str(), port))?
    .run()
    .await
}
