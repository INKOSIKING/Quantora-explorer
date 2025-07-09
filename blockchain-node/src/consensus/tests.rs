#[cfg(test)]
mod tests {
    use super::pow::PoWEngine;
    use super::pos::PoSEngine;
    use super::ConsensusEngine;
    use crate::blockchain::{Block, BlockHeader};
    use crate::mempool::Mempool;
    use std::collections::HashMap;

    fn dummy_block_header(miner: &str, nonce: u64) -> BlockHeader {
        BlockHeader {
            parent_hash: String::from("parent"),
            timestamp: 0,
            miner: miner.to_string(),
            nonce,
        }
    }

    fn dummy_block(miner: &str, nonce: u64) -> Block {
        Block {
            header: dummy_block_header(miner, nonce),
            transactions: vec![],
        }
    }

    #[test]
    fn pow_validate_and_propose() {
        let pow = PoWEngine { difficulty: u64::MAX }; // Easiest for test
        let mempool = Mempool::new();
        let block = pow.propose_block(&mempool, "parent", "miner1");
        assert!(pow.validate_block(&block));
    }

    #[test]
    fn pos_validate_and_propose() {
        let mut stakes = HashMap::new();
        stakes.insert("miner1".to_string(), 100);
        let pos = PoSEngine { stakes };
        let mempool = Mempool::new();
        let block = pos.propose_block(&mempool, "parent", "miner1");
        assert!(pos.validate_block(&block));
    }
}