use super::ConsensusEngine;
use crate::blockchain::{Block, BlockHeader};
use crate::mempool::Mempool;
use sha2::{Digest, Sha256};
use chrono::Utc;

pub struct PoWEngine {
    pub difficulty: u64,
}

impl PoWEngine {
    fn hash_with_nonce(header: &BlockHeader, nonce: u64) -> [u8; 32] {
        let mut hasher = Sha256::new();
        hasher.update(header.parent_hash.as_bytes());
        hasher.update(&header.timestamp.to_be_bytes());
        hasher.update(header.miner.as_bytes());
        hasher.update(&nonce.to_be_bytes());
        let result = hasher.finalize();
        let mut hash = [0u8; 32];
        hash.copy_from_slice(&result);
        hash
    }

    fn meets_difficulty(hash: &[u8; 32], difficulty: u64) -> bool {
        let mut value = 0u64;
        for i in 0..8 {
            value = (value << 8) | hash[i] as u64;
        }
        value < difficulty
    }
}

impl ConsensusEngine for PoWEngine {
    fn validate_block(&self, block: &Block) -> bool {
        let hash = PoWEngine::hash_with_nonce(&block.header, block.header.nonce);
        PoWEngine::meets_difficulty(&hash, self.difficulty)
    }

    fn propose_block(&self, mempool: &Mempool, parent_hash: &str, miner_address: &str) -> Block {
        let timestamp = Utc::now().timestamp();
        let transactions = mempool.get_transactions();
        let mut nonce = 0u64;
        loop {
            let header = BlockHeader {
                parent_hash: parent_hash.to_string(),
                timestamp,
                miner: miner_address.to_string(),
                nonce,
            };
            let hash = PoWEngine::hash_with_nonce(&header, nonce);
            if PoWEngine::meets_difficulty(&hash, self.difficulty) {
                return Block {
                    header,
                    transactions: transactions.clone(),
                };
            }
            nonce += 1;
        }
    }
}