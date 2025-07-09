use crate::models::{IndexedBlock, IndexedTx};
use chrono::Utc;
use sqlx::PgPool;
use uuid::Uuid;

pub async fn insert_block(pool: &PgPool, block: &IndexedBlock) -> sqlx::Result<()> {
    sqlx::query(
        "INSERT INTO indexed_blocks (id, hash, prev_hash, height, timestamp) VALUES ($1, $2, $3, $4, $5)
         ON CONFLICT (hash) DO NOTHING"
    )
    .bind(block.id)
    .bind(&block.hash)
    .bind(&block.prev_hash)
    .bind(block.height)
    .bind(block.timestamp)
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn insert_tx(pool: &PgPool, tx: &IndexedTx) -> sqlx::Result<()> {
    sqlx::query(
        "INSERT INTO indexed_transactions (id, from, to, amount, block_hash, signature, timestamp)
         VALUES ($1, $2, $3, $4, $5, $6, $7)
         ON CONFLICT (id) DO NOTHING",
    )
    .bind(tx.id)
    .bind(&tx.from)
    .bind(&tx.to)
    .bind(tx.amount)
    .bind(&tx.block_hash)
    .bind(&tx.signature)
    .bind(tx.timestamp)
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn get_latest_block(pool: &PgPool) -> sqlx::Result<Option<IndexedBlock>> {
    sqlx::query_as::<_, IndexedBlock>("SELECT * FROM indexed_blocks ORDER BY height DESC LIMIT 1")
        .fetch_optional(pool)
        .await
}

pub async fn get_block_by_hash(pool: &PgPool, hash: &str) -> sqlx::Result<Option<IndexedBlock>> {
    sqlx::query_as::<_, IndexedBlock>("SELECT * FROM indexed_blocks WHERE hash = $1")
        .bind(hash)
        .fetch_optional(pool)
        .await
}

pub async fn get_tx_by_id(pool: &PgPool, tx_id: &str) -> sqlx::Result<Option<IndexedTx>> {
    sqlx::query_as::<_, IndexedTx>("SELECT * FROM indexed_transactions WHERE id = $1")
        .bind(tx_id)
        .fetch_optional(pool)
        .await
}

pub async fn get_recent_blocks(pool: &PgPool, limit: i64) -> sqlx::Result<Vec<IndexedBlock>> {
    sqlx::query_as::<_, IndexedBlock>("SELECT * FROM indexed_blocks ORDER BY height DESC LIMIT $1")
        .bind(limit)
        .fetch_all(pool)
        .await
}

pub async fn get_recent_txs(pool: &PgPool, limit: i64) -> sqlx::Result<Vec<IndexedTx>> {
    sqlx::query_as::<_, IndexedTx>(
        "SELECT * FROM indexed_transactions ORDER BY timestamp DESC LIMIT $1",
    )
    .bind(limit)
    .fetch_all(pool)
    .await
}
