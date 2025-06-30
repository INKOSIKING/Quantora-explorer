
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use sha2::{Sha256, Digest};
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Block {
    pub index: u64,
    pub timestamp: DateTime<Utc>,
    pub previous_hash: String,
    pub hash: String,
    pub transactions: Vec<Transaction>,
    pub nonce: u64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Transaction {
    pub from: String,
    pub to: String,
    pub amount: u64,
    pub timestamp: DateTime<Utc>,
    pub signature: String,
}

pub struct Blockchain {
    pub chain: Vec<Block>,
    pub pending_transactions: Vec<Transaction>,
    pub balances: HashMap<String, u64>,
    pub difficulty: usize,
}

impl Blockchain {
    pub fn new() -> Self {
        let mut blockchain = Blockchain {
            chain: Vec::new(),
            pending_transactions: Vec::new(),
            balances: HashMap::new(),
            difficulty: 4,
        };
        
        // Create genesis block
        blockchain.create_genesis_block();
        blockchain
    }
    
    fn create_genesis_block(&mut self) {
        let genesis_block = Block {
            index: 0,
            timestamp: Utc::now(),
            previous_hash: "0".to_string(),
            hash: "0".to_string(),
            transactions: Vec::new(),
            nonce: 0,
        };
        
        self.chain.push(genesis_block);
    }
    
    pub fn add_transaction(&mut self, transaction: Transaction) -> Result<(), String> {
        // Basic validation
        if transaction.from == transaction.to {
            return Err("Cannot send to self".to_string());
        }
        
        if transaction.amount == 0 {
            return Err("Amount must be greater than 0".to_string());
        }
        
        // Check balance for non-mining transactions
        if transaction.from != "system" {
            let balance = self.balances.get(&transaction.from).unwrap_or(&0);
            if *balance < transaction.amount {
                return Err("Insufficient balance".to_string());
            }
        }
        
        self.pending_transactions.push(transaction);
        Ok(())
    }
    
    pub fn mine_block(&mut self, miner_address: String) -> Block {
        // Add mining reward
        let mining_reward = Transaction {
            from: "system".to_string(),
            to: miner_address,
            amount: 100,
            timestamp: Utc::now(),
            signature: "mining_reward".to_string(),
        };
        
        self.pending_transactions.push(mining_reward);
        
        let previous_block = self.chain.last().unwrap();
        let mut new_block = Block {
            index: previous_block.index + 1,
            timestamp: Utc::now(),
            previous_hash: previous_block.hash.clone(),
            hash: String::new(),
            transactions: self.pending_transactions.clone(),
            nonce: 0,
        };
        
        // Proof of work
        new_block.hash = self.proof_of_work(&mut new_block);
        
        // Update balances
        self.update_balances(&new_block.transactions);
        
        // Add block to chain
        self.chain.push(new_block.clone());
        
        // Clear pending transactions
        self.pending_transactions.clear();
        
        new_block
    }
    
    fn proof_of_work(&self, block: &mut Block) -> String {
        let target = "0".repeat(self.difficulty);
        
        loop {
            let hash = self.calculate_hash(block);
            if hash.starts_with(&target) {
                return hash;
            }
            block.nonce += 1;
        }
    }
    
    fn calculate_hash(&self, block: &Block) -> String {
        let mut hasher = Sha256::new();
        let block_string = format!(
            "{}{}{}{}{}",
            block.index,
            block.timestamp,
            block.previous_hash,
            serde_json::to_string(&block.transactions).unwrap_or_default(),
            block.nonce
        );
        hasher.update(block_string.as_bytes());
        format!("{:x}", hasher.finalize())
    }
    
    fn update_balances(&mut self, transactions: &[Transaction]) {
        for tx in transactions {
            if tx.from != "system" {
                let from_balance = self.balances.get(&tx.from).unwrap_or(&0);
                self.balances.insert(tx.from.clone(), from_balance - tx.amount);
            }
            
            let to_balance = self.balances.get(&tx.to).unwrap_or(&0);
            self.balances.insert(tx.to.clone(), to_balance + tx.amount);
        }
    }
    
    pub fn get_balance(&self, address: &str) -> u64 {
        *self.balances.get(address).unwrap_or(&0)
    }
    
    pub fn is_chain_valid(&self) -> bool {
        for i in 1..self.chain.len() {
            let current_block = &self.chain[i];
            let previous_block = &self.chain[i - 1];
            
            if current_block.hash != self.calculate_hash(current_block) {
                return false;
            }
            
            if current_block.previous_hash != previous_block.hash {
                return false;
            }
        }
        true
    }
}
