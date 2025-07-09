use serde::{Serialize, Deserialize};
use uuid::Uuid;
use chrono::{Utc, DateTime};

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Account {
    pub id: Uuid,
    pub username: String,
    pub email: String,
    pub password_hash: String,
    pub balance: f64,
    pub nonce: i64,
    pub created_at: DateTime<Utc>,
    pub updated_at: Option<DateTime<Utc>>,
    pub is_active: bool,
    pub is_validator: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Transaction {
    pub id: Uuid,
    pub from_account: Uuid,
    pub to_account: Uuid,
    pub amount: f64,
    pub fee: f64,
    pub tx_type: TransactionType,
    pub block_hash: Option<String>,
    pub status: TransactionStatus,
    pub timestamp: DateTime<Utc>,
    pub signature: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "transaction_type", rename_all = "lowercase")]
pub enum TransactionType {
    Transfer,
    Stake,
    ContractCall,
    Reward,
    Mint,
    Burn,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::Type)]
#[sqlx(type_name = "transaction_status", rename_all = "lowercase")]
pub enum TransactionStatus {
    Pending,
    Confirmed,
    Failed,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Block {
    pub hash: String,
    pub height: i64,
    pub prev_hash: String,
    pub merkle_root: String,
    pub timestamp: DateTime<Utc>,
    pub validator: Uuid,
    pub gas_used: i64,
    pub signature: String,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct SmartContract {
    pub id: Uuid,
    pub owner_id: Uuid,
    pub address: String,
    pub source_code: String,
    pub bytecode: String,
    pub abi: Option<String>,
    pub created_at: DateTime<Utc>,
    pub is_active: bool,
}
