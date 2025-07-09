use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct IndexedBlock {
    pub id: Uuid,
    pub hash: String,
    pub prev_hash: String,
    pub height: i64,
    pub timestamp: DateTime<Utc>,
}

#[derive(Debug, Serialize, Deserialize, Clone, sqlx::FromRow)]
pub struct IndexedTx {
    pub id: Uuid,
    pub from: String,
    pub to: String,
    pub amount: i64,
    pub block_hash: String,
    pub signature: String,
    pub timestamp: DateTime<Utc>,
}
