use super::ConsensusEngine;
use crate::blockchain::{Block, BlockHeader};
use crate::mempool::Mempool;
use std::collections::HashMap;
use chrono::Utc;
use std::time::{SystemTime, UNIX_EPOCH};

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
        let transactions = mempool.get_transactions();
        let timestamp = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs();

        let header = BlockHeader {
            index: 0, // This should be determined by the blockchain
            timestamp,
            previous_hash: parent_hash.to_string(),
            merkle_root: String::new(), // Calculate merkle root from transactions
            nonce: 0,
        };

        Block {
            header: header.clone(),
            index: 0,
            timestamp,
            previous_hash: parent_hash.to_string(),
            hash: String::new(),
            transactions,
            nonce: 0,
            miner_reward: 25, // Lower reward for PoS
        }
    }
}