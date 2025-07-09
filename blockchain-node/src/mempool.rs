
use crate::transaction::Transaction;
use std::collections::HashMap;

pub struct Mempool {
    pub transactions: HashMap<String, Transaction>,
    pub pending_transactions: Vec<Transaction>,
}

impl Mempool {
    pub fn new() -> Self {
        Mempool {
            transactions: HashMap::new(),
            pending_transactions: Vec::new(),
        }
    }

    pub fn add_transaction(&mut self, transaction: Transaction) {
        self.pending_transactions.push(transaction.clone());
        self.transactions.insert(transaction.id.clone(), transaction);
    }

    pub fn get_transactions(&self) -> Vec<Transaction> {
        self.pending_transactions.clone()
    }

    pub fn remove_transaction(&mut self, tx_id: &str) {
        self.transactions.remove(tx_id);
        self.pending_transactions.retain(|tx| tx.id != tx_id);
    }

    pub fn clear(&mut self) {
        self.transactions.clear();
        self.pending_transactions.clear();
    }
}
