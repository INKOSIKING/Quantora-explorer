use crate::{
    db,
    models::{IndexedBlock, IndexedTx},
};
use chrono::{DateTime, Utc};
use log::{error, info};
use reqwest::Client;
use serde::Deserialize;
use sqlx::PgPool;
use uuid::Uuid;

#[derive(Deserialize)]
struct ApiBlock {
    id: String,
    hash: String,
    prev_hash: String,
    height: i64,
    timestamp: String,
}

#[derive(Deserialize)]
struct ApiTx {
    id: String,
    from: String,
    to: String,
    amount: i64,
    block_hash: String,
    signature: String,
    timestamp: String,
}

pub async fn sync_blocks_and_txs(pool: PgPool, blockchain_api_url: String) -> anyhow::Result<()> {
    let client = Client::new();
    // For demo: assume /block/all and /tx/all endpoints exist in blockchain API
    let blocks_resp = client
        .get(format!("{}/block/all", blockchain_api_url))
        .send()
        .await?
        .json::<Vec<ApiBlock>>()
        .await?;
    let txs_resp = client
        .get(format!("{}/tx/all", blockchain_api_url))
        .send()
        .await?
        .json::<Vec<ApiTx>>()
        .await?;

    // Index new blocks
    for b in blocks_resp {
        let timestamp = DateTime::parse_from_rfc3339(&b.timestamp)?.with_timezone(&Utc);
        let block = IndexedBlock {
            id: Uuid::parse_str(&b.id)?,
            hash: b.hash,
            prev_hash: b.prev_hash,
            height: b.height,
            timestamp,
        };
        db::insert_block(&pool, &block).await?;
    }
    // Index new txs
    for t in txs_resp {
        let timestamp = DateTime::parse_from_rfc3339(&t.timestamp)?.with_timezone(&Utc);
        let tx = IndexedTx {
            id: Uuid::parse_str(&t.id)?,
            from: t.from,
            to: t.to,
            amount: t.amount,
            block_hash: t.block_hash,
            signature: t.signature,
            timestamp,
        };
        db::insert_tx(&pool, &tx).await?;
    }
    info!(
        "Indexer sync: indexed {} blocks, {} txs",
        blocks_resp.len(),
        txs_resp.len()
    );
    Ok(())
}
