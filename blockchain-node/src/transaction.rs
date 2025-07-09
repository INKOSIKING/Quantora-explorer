
use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Transaction {
    pub from: String,
    pub to: String,
    pub amount: u64,
    pub timestamp: DateTime<Utc>,
    pub signature: String,
    pub tx_type: TransactionType,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TransactionType {
    Transfer,
    Mining,
    Genesis,
}

impl Transaction {
    pub fn new(from: String, to: String, amount: u64) -> Self {
        Transaction {
            from,
            to,
            amount,
            timestamp: Utc::now(),
            signature: String::new(),
            tx_type: TransactionType::Transfer,
        }
    }
}
