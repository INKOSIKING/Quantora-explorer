#[cfg(test)]
mod tests {
    use super::super::Transaction;
    use super::*;
    use std::sync::Arc;

    fn dummy_transaction(n: u64) -> Transaction {
        Transaction {
            from: format!("from_{}", n),
            to: format!("to_{}", n),
            value: n * 1000,
            nonce: n,
            signature: format!("sig_{}", n),
            data: vec![],
        }
    }

    #[test]
    fn add_and_remove_transaction() {
        let mempool = Mempool::new();
        let tx = dummy_transaction(1);
        let hash = tx.hash();
        assert!(mempool.add_transaction(tx.clone()));
        assert!(mempool.contains(&hash));
        assert!(!mempool.add_transaction(tx)); // duplicate should fail
        mempool.remove_transaction(&hash);
        assert!(!mempool.contains(&hash));
    }

    #[test]
    fn get_transactions() {
        let mempool = Mempool::new();
        for i in 0..10 {
            let tx = dummy_transaction(i);
            mempool.add_transaction(tx);
        }
        let txs = mempool.get_transactions();
        assert_eq!(txs.len(), 10);
    }

    #[test]
    fn clear_mempool() {
        let mempool = Mempool::new();
        for i in 0..3 {
            mempool.add_transaction(dummy_transaction(i));
        }
        mempool.clear();
        assert_eq!(mempool.get_transactions().len(), 0);
    }
}