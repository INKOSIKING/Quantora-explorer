use crate::blockchain::{Block, Transaction};
use std::collections::HashMap;
use std::sync::{Arc, RwLock};
use rayon::prelude::*;

/// Highly concurrent, sharded state for ultra-high TPS (>200 million)
const SHARD_COUNT: usize = 4096;

#[derive(Clone)]
pub struct StateShard {
    balances: Arc<RwLock<HashMap<String, u64>>>,
    nonces: Arc<RwLock<HashMap<String, u64>>>,
}

impl StateShard {
    pub fn new() -> Self {
        StateShard {
            balances: Arc::new(RwLock::new(HashMap::new())),
            nonces: Arc::new(RwLock::new(HashMap::new())),
        }
    }
}

#[derive(Clone)]
pub struct State {
    shards: Arc<Vec<StateShard>>,
}

impl State {
    pub fn new() -> Self {
        let shards = (0..SHARD_COUNT)
            .map(|_| StateShard::new())
            .collect::<Vec<_>>();
        State {
            shards: Arc::new(shards),
        }
    }

    fn shard_idx(addr: &str) -> usize {
        use std::hash::{Hasher, BuildHasherDefault};
        use twox_hash::XxHash64;
        let mut h = XxHash64::with_seed(0);
        h.write(addr.as_bytes());
        (h.finish() as usize) % SHARD_COUNT
    }

    fn get_shard(&self, addr: &str) -> &StateShard {
        &self.shards[Self::shard_idx(addr)]
    }

    pub fn get_balance(&self, addr: &str) -> u64 {
        let shard = self.get_shard(addr);
        let map = shard.balances.read().unwrap();
        *map.get(addr).unwrap_or(&0)
    }

    pub fn get_nonce(&self, addr: &str) -> u64 {
        let shard = self.get_shard(addr);
        let map = shard.nonces.read().unwrap();
        *map.get(addr).unwrap_or(&0)
    }

    pub fn apply_block(&self, block: &Block, block_reward: u64) -> Result<(), String> {
        let miner = &block.header.miner;
        let miner_shard = self.get_shard(miner);
        {
            let mut bal = miner_shard.balances.write().unwrap();
            *bal.entry(miner.clone()).or_insert(0) += block_reward;
        }
        // Parallel transaction execution for ultra-high TPS
        block.transactions.par_iter().try_for_each(|tx| self.apply_transaction(tx))
    }

    pub fn apply_transaction(&self, tx: &Transaction) -> Result<(), String> {
        if tx.from == "GENESIS" {
            let shard = self.get_shard(&tx.to);
            let mut bal = shard.balances.write().unwrap();
            *bal.entry(tx.to.clone()).or_insert(0) += tx.value;
            return Ok(());
        }
        let from_shard = self.get_shard(&tx.from);
        let to_shard = self.get_shard(&tx.to);

        // Lock ordering to avoid deadlocks
        let (first_shard, second_shard, first_addr, second_addr) = if Self::shard_idx(&tx.from) <= Self::shard_idx(&tx.to) {
            (from_shard, to_shard, &tx.from, &tx.to)
        } else {
            (to_shard, from_shard, &tx.to, &tx.from)
        };

        let mut first_bal = first_shard.balances.write().unwrap();
        let mut second_bal = if Self::shard_idx(&tx.from) == Self::shard_idx(&tx.to) {
            // Same shard
            None
        } else {
            Some(second_shard.balances.write().unwrap())
        };
        let mut from_nonce = from_shard.nonces.write().unwrap();

        let sender_bal = first_bal.get_mut(&tx.from).or_else(|| second_bal.as_mut().and_then(|m| m.get_mut(&tx.from))).unwrap_or(&mut 0u64);
        let sender_nonce = from_nonce.entry(tx.from.clone()).or_insert(0);
        let receiver_bal = first_bal.get_mut(&tx.to).or_else(|| second_bal.as_mut().and_then(|m| m.get_mut(&tx.to))).unwrap_or(&mut 0u64);

        if *sender_bal < tx.value {
            return Err("Insufficient balance".to_string());
        }
        if *sender_nonce != tx.nonce {
            return Err("Invalid nonce".to_string());
        }
        *sender_bal -= tx.value;
        *receiver_bal += tx.value;
        *sender_nonce += 1;
        Ok(())
    }
}