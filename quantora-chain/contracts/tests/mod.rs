#[cfg(test)]
mod tests {
    use super::super::erc20::QuantoraToken;
    use ink_env::{test, DefaultEnvironment};
    use ink_lang as ink;

    #[ink::test]
    fn erc20_works() {
        let accounts = test::default_accounts::<DefaultEnvironment>();
        let initial_supply = 1_000_000u128;
        let mut token = QuantoraToken::new(initial_supply);

        // Owner receives initial supply
        assert_eq!(token.balance_of(accounts.alice), initial_supply);

        // Transfer tokens
        assert!(token.transfer(accounts.bob, 100_000));
        assert_eq!(token.balance_of(accounts.bob), 100_000);
        assert_eq!(token.balance_of(accounts.alice), initial_supply - 100_000);

        // Approve and transferFrom
        assert!(token.approve(accounts.bob, 50_000));
        assert_eq!(token.allowance(accounts.alice, accounts.bob), 50_000);

        // Bob performs transferFrom
        test::set_caller::<DefaultEnvironment>(accounts.bob);
        assert!(token.transfer_from(accounts.alice, accounts.eve, 50_000));
        assert_eq!(token.balance_of(accounts.eve), 50_000);
        assert_eq!(token.allowance(accounts.alice, accounts.bob), 0);
    }

    // Add more tests for edge cases and failure conditions as needed
}