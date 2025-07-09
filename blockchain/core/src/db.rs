use crate::models::{Account, Transaction, Block};
use sqlx::{PgPool, Row};
use uuid::Uuid;
use chrono::Utc;

pub async fn get_account(pool: &PgPool, address: &str) -> sqlx::Result<Option<Account>> {
    sqlx::query_as::<_, Account>("SELECT * FROM accounts WHERE address = $1")
        .bind(address)
        .fetch_optional(pool)
        .await
}

pub async fn create_account(pool: &PgPool, address: &str) -> sqlx::Result<Account> {
    let id = Uuid::new_v4();
    let now = Utc::now();
    sqlx::query_as::<_, Account>(
        "INSERT INTO accounts (id, address, balance, created_at) VALUES ($1, $2, 0, $3) RETURNING *"
    )
    .bind(id)
    .bind(address)
    .bind(now)
    .fetch_one(pool)
    .await
}

pub async fn update_account_balance(pool: &PgPool, address: &str, balance: i64) -> sqlx::Result<()> {
    sqlx::query("UPDATE accounts SET balance = $1 WHERE address = $2")
        .bind(balance)
        .bind(address)
        .execute(pool)
        .await?;
    Ok(())
}

pub async fn insert_transaction(pool: &PgPool, tx: &Transaction) -> sqlx::Result<()> {
    sqlx::query(
        "INSERT INTO transactions (id, from, to, amount, nonce, block_hash, signature, timestamp, status) VALUES \
         ($1, $2, $3, $4, $5, $6, $7, $8, $9)"
    )
    .bind(tx.id)
    .bind(&tx.from)
    .bind(&tx.to)
    .bind(tx.amount)
    .bind(tx.nonce)
    .bind(&tx.block_hash)
    .bind(&tx.signature)
    .bind(tx.timestamp)
    .bind(&tx.status)
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn get_pending_transactions(pool: &PgPool) -> sqlx::Result<Vec<Transaction>> {
    sqlx::query_as::<_, Transaction>("SELECT * FROM transactions WHERE status = 'pending'")
        .fetch_all(pool)
        .await
}

pub async fn confirm_transaction(pool: &PgPool, tx_id: Uuid, block_hash: &str) -> sqlx::Result<()> {
    sqlx::query("UPDATE transactions SET status = 'confirmed', block_hash = $1 WHERE id = $2")
        .bind(block_hash)
        .bind(tx_id)
        .execute(pool)
        .await?;
    Ok(())
}

pub async fn insert_block(pool: &PgPool, block: &Block) -> sqlx::Result<()> {
    sqlx::query(
        "INSERT INTO blocks (id, hash, prev_hash, height, timestamp) VALUES ($1, $2, $3, $4, $5)"
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

pub async fn get_last_block(pool: &PgPool) -> sqlx::Result<Option<Block>> {
    sqlx::query_as::<_, Block>("SELECT * FROM blocks ORDER BY height DESC LIMIT 1")
        .fetch_optional(pool)
        .await
}