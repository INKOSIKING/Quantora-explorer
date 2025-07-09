use std::collections::{BTreeMap, HashMap};
use crate::types::Transaction;

pub struct Mempool {
    pool: BTreeMap<u64, Vec<Transaction>>, // fee_priority -> txs
    tx_index: HashMap<String, u64>,
    max_size: usize,
}

impl Mempool {
    pub fn new(max_size: usize) -> Self {
        Self {
            pool: BTreeMap::new(),
            tx_index: HashMap::new(),
            max_size,
        }
    }
    pub fn insert(&mut self, tx: Transaction) -> Result<(), &'static str> {
        let fee_priority = tx.gas_price * tx.gas_limit;
        if self.tx_index.contains_key(&tx.hash) { return Err("Duplicate"); }
        if self.size() >= self.max_size { self.prune_lowest(); }
        self.pool.entry(fee_priority).or_default().push(tx.clone());
        self.tx_index.insert(tx.hash.clone(), fee_priority);
        Ok(())
    }
    fn prune_lowest(&mut self) {
        if let Some((&lowest, txs)) = self.pool.iter_mut().next() {
            if let Some(tx) = txs.pop() {
                self.tx_index.remove(&tx.hash);
            }
            if txs.is_empty() { self.pool.remove(&lowest); }
        }
    }
    pub fn spam_protect(&self, tx: &Transaction) -> bool {
        // e.g., limit per address, per block, input data checks
        true
    }
    pub fn get_highest(&self, n: usize) -> Vec<&Transaction> {
        self.pool.iter().rev().flat_map(|(_, txs)| txs.iter()).take(n).collect()
    }
}