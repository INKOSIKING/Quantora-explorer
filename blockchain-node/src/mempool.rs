
use crate::blockchain::Transaction;
use std::collections::HashMap;

pub struct Mempool {
    transactions: HashMap<String, Transaction>,
    max_size: usize,
}

impl Mempool {
    pub fn new(max_size: usize) -> Self {
        Self {
            transactions: HashMap::new(),
            max_size,
        }
    }

    pub fn add_transaction(&mut self, tx: Transaction) -> Result<(), String> {
        if self.transactions.len() >= self.max_size {
            return Err("Mempool is full".to_string());
        }

        let tx_hash = tx.hash();
        self.transactions.insert(tx_hash, tx);
        Ok(())
    }

    pub fn get_transactions(&self) -> Vec<Transaction> {
        self.transactions.values().cloned().collect()
    }

    pub fn remove_transaction(&mut self, tx_hash: &str) -> Option<Transaction> {
        self.transactions.remove(tx_hash)
    }

    pub fn clear(&mut self) {
        self.transactions.clear();
    }

    pub fn size(&self) -> usize {
        self.transactions.len()
    }
}
