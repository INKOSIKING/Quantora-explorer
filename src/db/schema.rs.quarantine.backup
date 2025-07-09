
use tokio_postgres::Client;
use tracing::{info, error};

/// Creates the `blocks` table if it doesn't already exist.
/// Ensures schema safety for blockchain core operations.
pub async fn create_blocks_table_if_not_exists(client: &Client) {
    let create_table_sql = r#"
        CREATE TABLE IF NOT EXISTS blocks (
            id SERIAL PRIMARY KEY,
            hash TEXT UNIQUE NOT NULL,
            parent_hash TEXT,
            number BIGINT NOT NULL,
            timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
            miner TEXT,
            difficulty NUMERIC,
            nonce TEXT,
            size INTEGER,
            gas_limit BIGINT,
            gas_used BIGINT,
            transactions_root TEXT,
            state_root TEXT,
            receipts_root TEXT,
            extra_data TEXT,
            logs_bloom TEXT,
            created_at TIMESTAMPTZ DEFAULT now()
        );
    "#;

    match client.execute(create_table_sql, &[]).await {
        Ok(_) => info!("📦 'blocks' table checked/created successfully."),
        Err(e) => error!("❌ Failed to create 'blocks' table: {}", e),
    }
}

