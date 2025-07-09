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
            Some(selected) => block.header.validator == selected,
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
            merkle_root: Self::calculate_merkle_root(&transactions),
            validator: miner_address.to_string(),
            dag_edges: vec![],
            bft_round: 0,
            zk_proof: None,
        };

        Block {
            header,
            hash: String::new(), // Will be calculated later
            transactions,
            validator_reward: 0,
            dag_weight: 0,
            bft_signatures: vec![],
            rollup_batch_size: 10000,
        }
    }

    fn calculate_merkle_root(transactions: &[crate::blockchain::Transaction]) -> String {
        if transactions.is_empty() {
            return "empty_merkle_root".to_string();
        }
        
        use sha2::{Digest, Sha256};
        let mut hasher = Sha256::new();
        for tx in transactions {
            hasher.update(format!("{}{}{}", tx.from, tx.to, tx.amount));
        }
        format!("{:x}", hasher.finalize())ash.to_string(),
            validator: miner_address.to_string(),
            dag_edges: vec![],
            bft_round: 0,
            zk_proof: None,
        };

        Block {
            header,
            hash: String::new(),
            transactions,
            validator_reward: 1000,
            dag_weight: 1,
            bft_signatures: vec![miner_address.to_string()],
            rollup_batch_size: 1000,
        }
    }
}