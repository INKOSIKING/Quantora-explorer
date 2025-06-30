
use crate::blockchain::Blockchain;
use std::sync::Arc;
use tokio::sync::Mutex;
use tokio::time::{sleep, Duration};
use log::info;

pub struct ConsensusEngine {
    mining_enabled: bool,
    miner_address: String,
}

impl ConsensusEngine {
    pub fn new() -> Self {
        ConsensusEngine {
            mining_enabled: true,
            miner_address: "miner_1".to_string(),
        }
    }
    
    pub async fn start(&self, blockchain: Arc<Mutex<Blockchain>>) {
        info!("Starting consensus engine...");
        
        loop {
            if self.mining_enabled {
                self.mine_block(blockchain.clone()).await;
            }
            
            // Wait before next mining attempt
            sleep(Duration::from_secs(10)).await;
        }
    }
    
    async fn mine_block(&self, blockchain: Arc<Mutex<Blockchain>>) {
        let mut chain = blockchain.lock().await;
        
        if !chain.pending_transactions.is_empty() {
            info!("Mining new block with {} transactions", chain.pending_transactions.len());
            let block = chain.mine_block(self.miner_address.clone());
            info!("Block mined! Index: {}, Hash: {}", block.index, block.hash);
        }
    }
    
    pub fn set_miner_address(&mut self, address: String) {
        self.miner_address = address;
    }
    
    pub fn enable_mining(&mut self) {
        self.mining_enabled = true;
    }
    
    pub fn disable_mining(&mut self) {
        self.mining_enabled = false;
    }
}
