use std::env;
use tokio_postgres::{Client, NoTls, Error};
use dotenv::dotenv;
use tracing::{info, error};

/// Initializes a PostgreSQL database connection.
/// Loads env vars and connects using tokio-postgres.
/// Returns: Result<Client, Error>
pub async fn connect_db() -> Result<Client, Error> {
    dotenv().ok();

    let host = env::var("PGHOST").unwrap_or("localhost".to_string());
    let port = env::var("PGPORT").unwrap_or("5432".to_string());
    let user = env::var("PGUSER").unwrap_or("postgres".to_string());
    let password = env::var("PGPASSWORD").unwrap_or("password".to_string());
    let dbname = env::var("PGDATABASE").unwrap_or("quantora_db".to_string());

    let conn_str = format!(
        "host={} port={} user={} password={} dbname={}",
        host, port, user, password, dbname
    );

    match tokio_postgres::connect(&conn_str, NoTls).await {
        Ok((client, connection)) => {
            tokio::spawn(async move {
                if let Err(e) = connection.await {
                    error!("❌ Connection error: {}", e);
                }
            });
            info!("✅ PostgreSQL connected successfully.");
            Ok(client)
        },
        Err(e) => {
            error!("❌ Failed to connect to PostgreSQL: {}", e);
            Err(e)
        }
    }
}
