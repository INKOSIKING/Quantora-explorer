use crate::blockchain::Transaction;
use std::collections::{HashMap, HashSet};
use std::sync::{Arc, Mutex};

#[derive(Clone)]
pub struct Mempool {
    txs: Arc<Mutex<HashMap<String, Transaction>>>, // tx_hash -> transaction
    known_hashes: Arc<Mutex<HashSet<String>>>,
}

impl Mempool {
    pub fn new() -> Self {
        Mempool {
            txs: Arc::new(Mutex::new(HashMap::new())),
            known_hashes: Arc::new(Mutex::new(HashSet::new())),
        }
    }

    pub fn add_transaction(&self, tx: Transaction) -> bool {
        let tx_hash = tx.hash();
        let mut known = self.known_hashes.lock().unwrap();
        if known.contains(&tx_hash) {
            return false;
        }
        known.insert(tx_hash.clone());
        let mut map = self.txs.lock().unwrap();
        map.insert(tx_hash, tx);
        true
    }

    pub fn remove_transaction(&self, tx_hash: &str) {
        let mut known = self.known_hashes.lock().unwrap();
        let mut map = self.txs.lock().unwrap();
        known.remove(tx_hash);
        map.remove(tx_hash);
    }

    pub fn get_transactions(&self) -> Vec<Transaction> {
        let map = self.txs.lock().unwrap();
        map.values().cloned().collect()
    }

    pub fn contains(&self, tx_hash: &str) -> bool {
        let known = self.known_hashes.lock().unwrap();
        known.contains(tx_hash)
    }

    pub fn clear(&self) {
        let mut known = self.known_hashes.lock().unwrap();
        let mut map = self.txs.lock().unwrap();
        known.clear();
        map.clear();
    }
}