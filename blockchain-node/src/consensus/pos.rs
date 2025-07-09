use super::ConsensusEngine;
use crate::blockchain::{Block, BlockHeader};
use crate::mempool::Mempool;
use std::collections::HashMap;
use std::time::{SystemTime, UNIX_EPOCH};
use sha2::Digest;

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
            merkle_root: calculate_merkle_root(&transactions),
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

    }

fn calculate_merkle_root(transactions: &[crate::blockchain::Transaction]) -> String {
    if transactions.is_empty() {
        return String::from("0");
    }

    let mut hashes: Vec<String> = transactions.iter().map(|tx| {
        let serialized = serde_json::to_string(tx).unwrap();
        hex::encode(sha2::Sha256::digest(serialized.as_bytes()))
    }).collect();

    while hashes.len() > 1 {
        let mut new_hashes = vec![];
        for i in (0..hashes.len()).step_by(2) {
            let left = &hashes[i];
            let right = if i + 1 < hashes.len() { &hashes[i + 1] } else { left };
            let combined = format!("{}{}", left, right);
            let hash = hex::encode(sha2::Sha256::digest(combined.as_bytes()));
            new_hashes.push(hash);
        }
        hashes = new_hashes;
    }

    hashes[0].clone()
}