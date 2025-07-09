use super::ConsensusEngine;
use crate::blockchain::{Block, BlockHeader};
use crate::mempool::Mempool;
use sha2::{Digest, Sha256};
use chrono::Utc;
use std::time::{SystemTime, UNIX_EPOCH};

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
        let transactions = mempool.get_transactions();
        let timestamp = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs();

        let header = BlockHeader {
            index: 0, // This should be determined by the blockchain
            timestamp,
            parent_hash: parent_hash.to_string(),
            miner: miner_address.to_string(),
            nonce: 0,
        };

        let mut block = Block {
            header: header.clone(),
            transactions,
        };
        
        loop {
            let hash = PoWEngine::hash_with_nonce(&block.header, block.header.nonce);
            if PoWEngine::meets_difficulty(&hash, self.difficulty) {
                return block;
            }
            block.header.nonce += 1;
        }
    }
}