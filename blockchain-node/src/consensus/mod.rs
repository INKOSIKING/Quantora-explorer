pub mod pow;
pub mod pos;

use crate::blockchain::{Block, BlockHeader};
use crate::mempool::Mempool;

pub enum ConsensusType {
    PoW,
    PoS,
}

pub struct ConsensusConfig {
    pub consensus_type: ConsensusType,
    pub difficulty: u64, // For PoW
    // Add other config as needed
}

pub trait ConsensusEngine {
    fn validate_block(&self, block: &Block) -> bool;
    fn propose_block(&self, mempool: &Mempool) -> Block;
}