use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use uuid::Uuid;
use validator::Validate;
use serde_json::Value;

/// Enum for transaction status — prevents invalid strings.
#[derive(Debug, Serialize, Deserialize, sqlx::Type, Clone, Copy)]
#[sqlx(type_name = "tx_status", rename_all = "lowercase")]
pub enum TxStatus {
    Pending,
    Confirmed,
    Failed,
}

/// Transaction model — validated and production-safe.
#[derive(Debug, Serialize, Deserialize, FromRow, Validate)]
pub struct Transaction {
    pub id: Uuid,

    pub from: Uuid,
    pub to: Uuid,

    #[validate(range(min = 0))]
    pub amount: i64,

    pub timestamp: DateTime<Utc>,

    #[validate(range(min = 0))]
    pub nonce: i64,

    /// Optional hash of the block this tx belongs to.
    #[validate(length(min = 1))]
    pub block_hash: Option<String>,

    /// Optional cryptographic signature.
    #[validate(length(min = 1))]
    pub signature: Option<String>,

    /// Status (Pending, Confirmed, Failed).
    pub status: Option<TxStatus>,
}

/// Block model — includes height and hash info.
#[derive(Debug, Serialize, Deserialize, FromRow, Validate)]
pub struct Block {
    pub id: Uuid,

    /// Hash of the previous block.
    #[validate(length(min = 1))]
    pub previous_hash: String,

    /// Transaction list as array of Uuid OR store JSONB array in DB.
    pub transactions: Value, // Stored as JSONB in PostgreSQL

    pub timestamp: DateTime<Utc>,

    /// Hash of this block.
    #[validate(length(min = 1))]
    pub hash: String,

    /// Block height (0 = genesis)
    #[validate(range(min = 0))]
    pub height: i64,

    /// Optional duplicate of previous_hash (only if needed elsewhere).
    pub prev_hash: Option<String>,
}
use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};
use uuid::Uuid;
use validator::Validate;

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct User {
    pub id: Uuid,
    pub username: String,
    pub email: String,
    pub password_hash: String,
    pub wallet_address: String,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Block {
    pub id: Uuid,
    pub index: i64,
    pub hash: String,
    pub previous_hash: String,
    pub timestamp: DateTime<Utc>,
    pub nonce: i64,
    pub merkle_root: String,
    pub difficulty: i32,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Transaction {
    pub id: Uuid,
    pub hash: String,
    pub from_address: String,
    pub to_address: String,
    pub amount: i64,
    pub fee: i64,
    pub signature: String,
    pub timestamp: DateTime<Utc>,
    pub block_id: Option<Uuid>,
    pub status: TransactionStatus,
    pub created_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "transaction_status", rename_all = "lowercase")]
pub enum TransactionStatus {
    Pending,
    Confirmed,
    Failed,
}

#[derive(Debug, Clone, Serialize, Deserialize, Validate)]
pub struct CreateTransactionRequest {
    #[validate(length(min = 1))]
    pub to_address: String,
    #[validate(range(min = 1))]
    pub amount: i64,
    pub fee: Option<i64>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct WalletBalance {
    pub address: String,
    pub balance: i64,
    pub pending_balance: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BlockInfo {
    pub block: Block,
    pub transaction_count: i64,
    pub total_amount: i64,
}
