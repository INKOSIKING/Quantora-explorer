use crate::storage::{Block, Storage};
use std::sync::{Arc, Mutex};
use std::time::{SystemTime, UNIX_EPOCH};
use log::{info, error};
use sha2::{Digest, Sha256};

pub struct Consensus {
    storage: Arc<Mutex<Storage>>,
    difficulty: u32,
}

impl Consensus {
    pub fn new(storage: Arc<Mutex<Storage>>, difficulty: u32) -> Self {
        Self { storage, difficulty }
    }

    pub fn status(&self) -> String {
        format!("PoW, difficulty: {}", self.difficulty)
    }

    pub fn mine_block(&self, txs: Vec<String>) -> Option<Block> {
        let storage = self.storage.lock().unwrap();
        let prev_height = storage.tip_height();
        let prev_block = storage.get_block_by_height(prev_height as usize);
        let prev_hash = match prev_block {
            Some(b) => b.hash,
            None => "0".repeat(64),
        };
        drop(storage);

        let mut nonce = 0u64;
        let timestamp = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs();
        loop {
            let block = Block {
                height: prev_height + 1,
                hash: "".to_string(),
                prev_hash: prev_hash.clone(),
                timestamp,
                txs: txs.clone(),
                nonce,
            };
            let hash = Self::compute_hash(&block);
            if Self::valid_pow(&hash, self.difficulty) {
                let mut mined_block = block;
                mined_block.hash = hash.clone();
                info!("Block mined at height {} with nonce {}: {}", mined_block.height, nonce, hash);
                return Some(mined_block);
            }
            nonce += 1;
            if nonce % 100_000 == 0 {
                info!("Mining... nonce {}", nonce);
            }
        }
    }

    pub fn validate_block(&self, block: &Block) -> bool {
        // Validate hash, prev_hash, difficulty, etc.
        let hash = Self::compute_hash(block);
        if hash != block.hash {
            error!("Invalid block hash at height {}: expected {}, got {}", block.height, hash, block.hash);
            return false;
        }
        if !Self::valid_pow(&hash, self.difficulty) {
            error!("Block at height {} does not meet difficulty", block.height);
            return false;
        }
        true
    }

    fn compute_hash(block: &Block) -> String {
        let mut hasher = Sha256::new();
        hasher.update(block.height.to_le_bytes());
        hasher.update(block.prev_hash.as_bytes());
        hasher.update(block.timestamp.to_le_bytes());
        for tx in &block.txs {
            hasher.update(tx.as_bytes());
        }
        hasher.update(block.nonce.to_le_bytes());
        format!("{:x}", hasher.finalize())
    }

    fn valid_pow(hash: &str, difficulty: u32) -> bool {
        let prefix = "0".repeat(difficulty as usize);
        hash.starts_with(&prefix)
    }
}