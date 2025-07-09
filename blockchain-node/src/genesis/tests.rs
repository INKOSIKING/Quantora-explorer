#[cfg(test)]
mod tests {
    use super::*;
    use crate::blockchain::transaction::Transaction;

    #[test]
    fn genesis_block_creation() {
        let admin = GenesisAllocation {
            address: "admin_qta".into(),
            amount: 4_000_000_000_000,
        };
        let locked = GenesisAllocation {
            address: "locked_qta".into(),
            amount: 2_000_000_000_000,
        };
        let user1 = GenesisAllocation {
            address: "user1".into(),
            amount: 100,
        };
        let genesis_cfg = GenesisConfig {
            allocations: vec![user1],
            locked_address: locked.address.clone(),
            locked_amount: locked.amount,
            admin_address: admin.address.clone(),
            admin_amount: admin.amount,
            mining_supply: 14_000_000_000_000,
        };

        let block = create_genesis_block(&genesis_cfg);
        assert_eq!(block.transactions.len(), 3);
        assert_eq!(block.transactions[0].value, admin.amount);
        assert_eq!(block.transactions[1].value, locked.amount);
        assert_eq!(block.transactions[2].value, 100);
        assert_eq!(genesis_cfg.total_supply(), 20_000_000_000_100);
    }
}