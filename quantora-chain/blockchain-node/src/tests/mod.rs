#[cfg(test)]
mod tests {
    use super::super::network::Network;
    use super::super::storage::{Block, Storage};
    use super::super::consensus::Consensus;
    use std::net::SocketAddr;
    use std::sync::{Arc, Mutex};
    use std::time::{SystemTime, UNIX_EPOCH};

    #[test]
    fn test_block_storage_and_retrieval() {
        let tmp_dir = tempfile::tempdir().unwrap();
        let mut storage = Storage::new(tmp_dir.path());
        let block = Block {
            height: 1,
            hash: "abc123".to_string(),
            prev_hash: "def456".to_string(),
            timestamp: 1234567890,
            txs: vec!["tx1".to_string(), "tx2".to_string()],
            nonce: 99,
        };
        storage.save_block(&block).unwrap();
        let loaded = storage.get_block_by_height(1).unwrap();
        assert_eq!(loaded.hash, "abc123");
        assert_eq!(loaded.txs.len(), 2);
    }

    #[test]
    fn test_network_peer_add_remove() {
        let network = Network::new("127.0.0.1:0").unwrap();
        let addr: SocketAddr = "127.0.0.1:30333".parse().unwrap();
        network.add_peer(addr);
        assert!(network.peers().contains(&addr));
        network.remove_peer(&addr);
        assert!(!network.peers().contains(&addr));
    }

    #[test]
    fn test_consensus_mining_and_validation() {
        let tmp_dir = tempfile::tempdir().unwrap();
        let storage = Arc::new(Mutex::new(Storage::new(tmp_dir.path())));
        let consensus = Consensus::new(storage.clone(), 2);

        let txs = vec!["txA".to_string(), "txB".to_string()];
        let block = consensus.mine_block(txs.clone()).unwrap();
        assert!(consensus.validate_block(&block));
        storage.lock().unwrap().save_block(&block).unwrap();

        let loaded = storage.lock().unwrap().get_block_by_height(block.height as usize).unwrap();
        assert_eq!(loaded.txs, txs);
    }
}