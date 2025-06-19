//! Multi-asset Wallet: Store, secure, manage all coins (integrates QuantoraWalletManager)

use rust_decimal::Decimal;
use std::collections::HashMap;
use crate::exchange::quantora_wallet::QuantoraWalletManager;

#[derive(Default)]
pub struct UserWallet {
    pub balances: HashMap<String, Decimal>, // symbol -> balance
    pub quantora_manager: QuantoraWalletManager,
}

impl UserWallet {
    pub fn deposit(&mut self, symbol: &str, amount: Decimal) {
        *self.balances.entry(symbol.to_string()).or_insert(Decimal::ZERO) += amount;
    }
    pub fn withdraw(&mut self, symbol: &str, amount: Decimal) -> bool {
        if let Some(balance) = self.balances.get_mut(symbol) {
            if *balance >= amount {
                *balance -= amount;
                return true;
            }
        }
        false
    }
    pub fn balance(&self, symbol: &str) -> Decimal {
        self.balances.get(symbol).cloned().unwrap_or(Decimal::ZERO)
    }

    /// Get Quantora chain wallet address for a given asset
    pub async fn get_chain_wallet(&self, symbol: &str) -> Option<String> {
        let wallets = self.quantora_manager.get_wallets_by_asset(symbol).await;
        wallets.get(0).cloned()
    }
}