use super::ConsensusEngine;
use crate::blockchain::{Block, BlockHeader};
use crate::mempool::Mempool;
use std::collections::HashMap;
use chrono::Utc;

pub struct PoSEngine {
    pub stakes: HashMap<String, u64>,
}

impl PoSEngine {
    fn select_validator(&self) -> Option<String> {
        // TODO: implement robust, secure stake-based validator selection
        // For now, select highest-stake address
        self.stakes.iter().max_by_key(|(_, stake)| *stake).map(|(addr, _)| addr.clone())
    }
}

impl ConsensusEngine for PoSEngine {
    fn validate_block(&self, block: &Block) -> bool {
        match self.select_validator() {
            Some(selected) => block.header.miner == selected,
            None => false,
        }
    }

    fn propose_block(&self, mempool: &Mempool, parent_hash: &str, miner_address: &str) -> Block {
        let timestamp = Utc::now().timestamp();
        let transactions = mempool.get_transactions();
        let header = BlockHeader {
            parent_hash: parent_hash.to_string(),
            timestamp,
            miner: miner_address.to_string(),
            nonce: 0,
        };
        Block {
            header,
            transactions: transactions.clone(),
        }
    }
}