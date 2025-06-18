// Module stub for demonstration
pub fn api_routes(cfg: &mut actix_web::web::ServiceConfig) {}
pub async fn health() -> &'static str { "ok" }
pub async fn stats_daily() -> &'static str { "stats" }
pub struct Indexer { pub tip: u64 }
impl Indexer {
    pub async fn new(_pool: sqlx::Pool<sqlx::Postgres>, _node_url: String) -> Indexer { Indexer { tip: 0 } }
    pub async fn sync(&mut self) -> Result<(), String> { Ok(()) }
}
