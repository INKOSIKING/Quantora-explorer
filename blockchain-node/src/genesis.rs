use crate::blockchain::{Block, BlockHeader, Transaction};
use chrono::Utc;

/// Initial allocation structure
pub struct GenesisAllocation {
    pub address: String,
    pub amount: u64,
}

/// Genesis configuration for the blockchain
pub struct GenesisConfig {
    pub allocations: Vec<GenesisAllocation>,
    pub locked_address: String,
    pub locked_amount: u64,
    pub admin_address: String,
    pub admin_amount: u64,
    pub mining_supply: u64,
}

impl GenesisConfig {
    /// Returns the total initial supply
    pub fn total_supply(&self) -> u64 {
        self.allocations.iter().map(|a| a.amount).sum::<u64>() +
            self.locked_amount +
            self.admin_amount +
            self.mining_supply
    }
}

/// Creates the genesis block and returns it.
/// All initial balances and locked funds are set here.
pub fn create_genesis_block(config: &GenesisConfig) -> Block {
    // Mint allocations to users, admin, and locked address as coinbase transactions
    let mut transactions: Vec<Transaction> = Vec::new();

    // Admin allocation
    if config.admin_amount > 0 {
        transactions.push(Transaction::genesis_mint(&config.admin_address, config.admin_amount));
    }

    // Locked allocation
    if config.locked_amount > 0 {
        transactions.push(Transaction::genesis_mint(&config.locked_address, config.locked_amount));
    }

    // User allocations
    for alloc in &config.allocations {
        if alloc.amount > 0 {
            transactions.push(Transaction::genesis_mint(&alloc.address, alloc.amount));
        }
    }

    // Mining supply is not minted at genesis, but tracked in protocol

    let header = BlockHeader {
        parent_hash: String::from("0"), // No parent for genesis
        timestamp: Utc::now().timestamp(),
        miner: String::from("genesis"),
        nonce: 0,
    };

    Block {
        header,
        transactions,
    }
}