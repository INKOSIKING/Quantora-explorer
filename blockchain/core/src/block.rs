use crate::models::Block;
use uuid::Uuid;
use chrono::{Utc, DateTime};

pub fn create_block(previous_hash: String, transactions: Vec<Uuid>) -> Block {
    Block {
        id: Uuid::new_v4(),
        previous_hash,
        transactions,
        timestamp: Utc::now(),
        hash: String::from("dummy_hash"), // You should replace this with real hashing logic
    }
}
