use sqlx::{PgPool, Error};
use std::env;

/// Initialize the PostgreSQL connection pool
pub async fn init_db_pool() -> Result<PgPool, Error> {
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    PgPool::connect(&database_url).await
}
