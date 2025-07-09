use sqlx::{Pool, Postgres};
use sqlx::migrate::Migrator;
use crate::config::Config;

pub type DbPool = Pool<Postgres>;

static MIGRATOR: Migrator = sqlx::migrate!(); 

pub async fn init_db(cfg: &Config) -> DbPool {
    let pool = Pool::<Postgres>::connect(&cfg.database_url)
        .await
        .expect("Failed to connect to database");
    MIGRATOR.run(&pool).await.expect("DB migrations failed");
    pool
}
