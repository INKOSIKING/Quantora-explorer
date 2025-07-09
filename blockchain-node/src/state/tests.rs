#[cfg(test)]
mod tests {
    use super::*;
    use crate::blockchain::{Block, BlockHeader, Transaction};

    fn basic_block(miner: &str, txs: Vec<Transaction>) -> Block {
        Block {
            header: BlockHeader {
                parent_hash: String::from("parent"),
                timestamp: 0,
                miner: miner.to_string(),
                nonce: 0,
            },
            transactions: txs,
        }
    }

    #[test]
    fn test_apply_coinbase_and_tx() {
        let mut state = State::new();
        let miner = "miner1";
        let user1 = "user1";
        let user2 = "user2";

        // Genesis: mint user1 1000
        let genesis_tx = Transaction::genesis_mint(user1, 1000);
        state.apply_transaction(&genesis_tx).unwrap();
        assert_eq!(state.get_balance(user1), 1000);

        // Block: miner gets reward, user1 sends to user2
        let tx1 = Transaction {
            from: user1.into(),
            to: user2.into(),
            value: 300,
            nonce: 0,
            signature: "sig".into(),
            data: vec![],
        };
        let block = basic_block(miner, vec![tx1]);
        state.apply_block(&block, 50).unwrap();

        assert_eq!(state.get_balance(miner), 50);
        assert_eq!(state.get_balance(user1), 700);
        assert_eq!(state.get_balance(user2), 300);
        assert_eq!(state.get_nonce(user1), 1);
    }

    #[test]
    fn test_insufficient_balance() {
        let mut state = State::new();
        let user1 = "user1";
        let user2 = "user2";
        let genesis_tx = Transaction::genesis_mint(user1, 100);
        state.apply_transaction(&genesis_tx).unwrap();

        let tx = Transaction {
            from: user1.into(),
            to: user2.into(),
            value: 200,
            nonce: 0,
            signature: "sig".into(),
            data: vec![],
        };

        let res = state.apply_transaction(&tx);
        assert!(res.is_err());
    }

    #[test]
    fn test_invalid_nonce() {
        let mut state = State::new();
        let user1 = "user1";
        let user2 = "user2";
        state.apply_transaction(&Transaction::genesis_mint(user1, 100)).unwrap();

        let tx = Transaction {
            from: user1.into(),
            to: user2.into(),
            value: 10,
            nonce: 1, // should be 0
            signature: "sig".into(),
            data: vec![],
        };

        let res = state.apply_transaction(&tx);
        assert!(res.is_err());
    }
}