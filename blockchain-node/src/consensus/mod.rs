pub mod pos;
pub mod hybrid;

use crate::blockchain::{Block, BlockHeader};
use crate::mempool::Mempool;

pub enum ConsensusType {
    PoS,
    Hybrid, // PoS + DPoS + DAG + BFT + ZK-Rollups
}

pub struct ConsensusConfig {
    pub consensus_type: ConsensusType,
    pub validator_count: u64,
    pub batch_size: u64, // For ZK-Rollups
    pub bft_threshold: u64, // Byzantine fault tolerance
}

pub trait ConsensusEngine {
    fn validate_block(&self, block: &Block) -> bool;
    fn propose_block(&self, mempool: &Mempool, parent_hash: &str, miner_address: &str) -> Block;
}