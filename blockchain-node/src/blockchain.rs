use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use chrono::{DateTime, Utc};
use bip39::{Mnemonic, Language};
use secp256k1::{SecretKey, PublicKey, Secp256k1};
use hex;
use std::collections::HashMap;
use rand::RngCore;
use serde_json;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct BlockHeader {
    pub index: u64,
    pub timestamp: u64,
    pub previous_hash: String,
    pub merkle_root: String,
    pub validator: String,
    pub dag_edges: Vec<String>,
    pub bft_round: u64,
    pub zk_proof: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Block {
    pub header: BlockHeader,
    pub hash: String,
    pub transactions: Vec<Transaction>,
    pub validator_reward: u64,
    pub dag_weight: u64,
    pub bft_signatures: Vec<String>,
    pub rollup_batch_size: u64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Transaction {
    pub from: String,
    pub to: String,
    pub amount: u64,
    pub timestamp: DateTime<Utc>,
    pub signature: String,
    pub tx_type: TransactionType,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum TransactionType {
    Transfer,
    Mining,
    Genesis,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Wallet {
    pub address: String,
    pub seed_phrase: String,
    pub private_key: String,
    pub public_key: String,
}

pub struct Blockchain {
    pub chain: Vec<Block>,
    pub pending_transactions: Vec<Transaction>,
    pub balances: HashMap<String, u64>,
    pub difficulty: usize,
    pub total_supply: u64,
    pub burned_supply: u64,
    pub mining_pool: u64,
    pub reserved_supply: u64,
    pub founder_wallet: Wallet,
}

impl Block {
    pub fn genesis() -> Block {
        let header = BlockHeader {
            index: 0,
            timestamp: 0,
            previous_hash: "0".to_string(),
            merkle_root: "0".to_string(),
            validator: "genesis".to_string(),
            dag_edges: vec![],
            bft_round: 0,
            zk_proof: None,
        };

        Block {
            header,
            hash: "genesis_block_hash_quantora_hybrid_consensus".to_string(),
            transactions: vec![],
            validator_reward: 0,
            dag_weight: 0,
            bft_signatures: vec!["genesis".to_string()],
            rollup_batch_size: 10000,
        }
    }
}

impl Blockchain {
    pub fn new() -> Self {
        let mut blockchain = Blockchain {
            chain: Vec::new(),
            pending_transactions: Vec::new(),
            balances: HashMap::new(),
            difficulty: 4,
            total_supply: 20_000_000_000_000, // 20 trillion QuanX
            burned_supply: 4_000_000_000_000,  // 4 trillion burned (untouchable)
            mining_pool: 10_000_000_000_000,   // 10 trillion for mining
            reserved_supply: 6_000_000_000_000, // 6 trillion for founder
            founder_wallet: Self::create_founder_wallet(),
        };

        blockchain.create_genesis_block();
        blockchain
    }

    fn create_founder_wallet() -> Wallet {
        // Generate the founder's seed phrase
        let mut entropy = [0u8; 16]; // 128-bit entropy for 12 words
        rand::thread_rng().fill_bytes(&mut entropy);
        let mnemonic = Mnemonic::from_entropy_in(Language::English, &entropy).unwrap();
        let seed_phrase = mnemonic.to_string();
        let seed = mnemonic.to_seed("");

        let secp = Secp256k1::new();
        let secret_key = SecretKey::from_slice(&seed[0..32]).unwrap();
        let public_key = PublicKey::from_secret_key(&secp, &secret_key);

        let address = Self::public_key_to_address(&public_key);

        Wallet {
            address,
            seed_phrase,
            private_key: hex::encode(secret_key.secret_bytes()),
            public_key: hex::encode(public_key.serialize()),
        }
    }

    fn public_key_to_address(public_key: &PublicKey) -> String {
        let mut hasher = Sha256::new();
        hasher.update(public_key.serialize());
        let hash = hasher.finalize();
        format!("QuanX{}", hex::encode(&hash[0..20]))
    }

    pub fn create_wallet() -> Wallet {
        let mut entropy = [0u8; 16]; // 128-bit entropy for 12 words
        rand::thread_rng().fill_bytes(&mut entropy);
        let mnemonic = Mnemonic::from_entropy_in(Language::English, &entropy).unwrap();
        let seed_phrase = mnemonic.to_string();
        let seed = mnemonic.to_seed("");

        let secp = Secp256k1::new();
        let secret_key = SecretKey::from_slice(&seed[0..32]).unwrap();
        let public_key = PublicKey::from_secret_key(&secp, &secret_key);

        let address = Self::public_key_to_address(&public_key);

        Wallet {
            address,
            seed_phrase,
            private_key: hex::encode(secret_key.secret_bytes()),
            public_key: hex::encode(public_key.serialize()),
        }
    }

    fn create_genesis_block(&mut self) {
        // Genesis block with founder allocation
        let genesis_transaction = Transaction {
            from: "genesis".to_string(),
            to: self.founder_wallet.address.clone(),
            amount: self.reserved_supply,
            timestamp: Utc::now(),
            signature: "genesis_allocation".to_string(),
            tx_type: TransactionType::Genesis,
        };

        let genesis_block = Block {
            header: BlockHeader {
                index: 0,
                timestamp: Utc::now().timestamp() as u64,
                previous_hash: "0".to_string(),
                merkle_root: "genesis_merkle_root".to_string(),
                validator: "genesis".to_string(),
                dag_edges: vec![],
                bft_round: 0,
                zk_proof: None,
            },
            hash: "genesis_hash".to_string(),
            transactions: vec![genesis_transaction.clone()],
            validator_reward: 0,
            dag_weight: 0,
            bft_signatures: vec!["genesis".to_string()],
            rollup_batch_size: 10000,
        };

        // Set founder's balance
        self.balances.insert(self.founder_wallet.address.clone(), self.reserved_supply);

        self.chain.push(genesis_block);

        println!("🚀 QuanX Blockchain Initialized!");
        println!("📊 Total Supply: {} QuanX", self.format_amount(self.total_supply));
        println!("🔥 Burned Supply: {} QuanX (untouchable)", self.format_amount(self.burned_supply));
        println!("⛏️  Mining Pool: {} QuanX", self.format_amount(self.mining_pool));
        println!("👤 Founder Allocation: {} QuanX", self.format_amount(self.reserved_supply));
        println!("🔑 Founder Wallet Address: {}", self.founder_wallet.address);
        println!("🌱 Founder Seed Phrase: {}", self.founder_wallet.seed_phrase);
    }

    fn format_amount(&self, amount: u64) -> String {
        if amount >= 1_000_000_000_000 {
            format!("{:.1}T", amount as f64 / 1_000_000_000_000.0)
        } else if amount >= 1_000_000_000 {
            format!("{:.1}B", amount as f64 / 1_000_000_000.0)
        } else if amount >= 1_000_000 {
            format!("{:.1}M", amount as f64 / 1_000_000.0)
        } else {
            amount.to_string()
        }
    }

    pub fn add_transaction(&mut self, transaction: Transaction) -> Result<(), String> {
        // Basic validation
        if transaction.from == transaction.to {
            return Err("Cannot send to self".to_string());
        }

        if transaction.amount == 0 {
            return Err("Amount must be greater than 0".to_string());
        }

        // Check balance for non-system transactions
        if transaction.from != "system" && transaction.from != "genesis" {
            let balance = self.balances.get(&transaction.from).unwrap_or(&0);
            if *balance < transaction.amount {
                return Err("Insufficient QuanX balance".to_string());
            }
        }

        self.pending_transactions.push(transaction);
        Ok(())
    }

    pub fn mine_block(&mut self, miner_address: String) -> Block {
        // Calculate mining reward (decreases over time)
        let current_height = self.chain.len() as u64;
        let base_reward = 1000; // Base reward in QuanX
        let halving_interval = 210000; // Halve every 210k blocks
        let halvings = current_height / halving_interval;
        let mining_reward = base_reward >> halvings.min(63); // Prevent overflow

        // Check if mining pool has enough
        let actual_reward = if self.mining_pool >= mining_reward {
            self.mining_pool -= mining_reward;
            mining_reward
        } else {
            let remaining = self.mining_pool;
            self.mining_pool = 0;
            remaining
        };

        // Add mining reward transaction
        if actual_reward > 0 {
            let mining_reward_tx = Transaction {
                from: "system".to_string(),
                to: miner_address.clone(),
                amount: actual_reward,
                timestamp: Utc::now(),
                signature: "mining_reward".to_string(),
                tx_type: TransactionType::Mining,
            };

            self.pending_transactions.push(mining_reward_tx);
        }

        let previous_block = self.chain.last().unwrap();
        let new_block = Block {
            header: BlockHeader {
                index: previous_block.header.index + 1,
                timestamp: Utc::now().timestamp() as u64,
                previous_hash: previous_block.hash.clone(),
                merkle_root: "temp_merkle_root".to_string(), // TODO: Implement merkle root calculation
                validator: "miner_address".to_string(), // Assuming miner_address is the validator
                dag_edges: vec![], // TODO: Implement DAG edges
                bft_round: 0,       // TODO: Implement BFT round
                zk_proof: None,      // TODO: Implement ZK-proof
            },
            hash: String::new(), // TODO: Implement block hashing
            transactions: self.pending_transactions.clone(),
            validator_reward: actual_reward,
            dag_weight: 0, // TODO: Implement DAG weight
            bft_signatures: vec![], // TODO: Implement BFT signatures
            rollup_batch_size: 10000,
        };

        // Update balances
        self.update_balances(&new_block.transactions);

        // Add block to chain
        self.chain.push(new_block.clone());

        // Clear pending transactions
        self.pending_transactions.clear();

        println!("⛏️  Block #{} mined! Reward: {} QuanX", new_block.header.index, self.format_amount(actual_reward));
        println!("🪙 Mining Pool Remaining: {} QuanX", self.format_amount(self.mining_pool));

        new_block
    }

    fn calculate_hash(&self, block: &Block) -> String {
        let mut hasher = Sha256::new();
        let block_string = format!(
            "{}{}{}{}{}{}",
            block.header.index,
            block.header.timestamp,
            block.header.previous_hash,
            serde_json::to_string(&block.transactions).unwrap_or_default(),
            block.header.validator,
            block.validator_reward
        );
        hasher.update(block_string.as_bytes());
        format!("{:x}", hasher.finalize())
    }

    fn update_balances(&mut self, transactions: &[Transaction]) {
        for tx in transactions {
            if tx.from != "system" && tx.from != "genesis" {
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

    pub fn get_founder_info(&self) -> &Wallet {
        &self.founder_wallet
    }

    pub fn get_blockchain_stats(&self) -> HashMap<String, String> {
        let mut stats = HashMap::new();
        stats.insert("total_supply".to_string(), self.format_amount(self.total_supply));
        stats.insert("burned_supply".to_string(), self.format_amount(self.burned_supply));
        stats.insert("mining_pool".to_string(), self.format_amount(self.mining_pool));
        stats.insert("founder_allocation".to_string(), self.format_amount(self.reserved_supply));
        stats.insert("blocks_mined".to_string(), self.chain.len().to_string());
        stats.insert("circulating_supply".to_string(), 
                    self.format_amount(self.total_supply - self.burned_supply - self.mining_pool));
        stats
    }

    pub fn is_chain_valid(&self) -> bool {
        for i in 1..self.chain.len() {
            let current_block = &self.chain[i];
            let previous_block = &self.chain[i - 1];

            if current_block.hash != self.calculate_hash(current_block) {
                return false;
            }

            if current_block.header.previous_hash != previous_block.hash {
                return false;
            }
        }
        true
    }
}

impl Transaction {
    pub fn hash(&self) -> String {
        let serialized = serde_json::to_string(self).unwrap();
        hex::encode(Sha256::digest(serialized.as_bytes()))
    }
}