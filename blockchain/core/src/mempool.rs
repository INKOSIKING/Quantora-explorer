
use crate::transaction::Transaction;

pub struct Mempool {
    pub transactions: Vec<Transaction>,
}

impl Mempool {
    pub fn new() -> Self {
        Self {
            transactions: vec![],
        }
    }
}

