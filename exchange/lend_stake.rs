//! Lending and Staking: Lend/stake QTA and any major asset, with APY

use rust_decimal::Decimal;
use std::collections::HashMap;
use chrono::{Utc, DateTime};

#[derive(Debug, Clone)]
pub struct StakeInfo {
    pub user: String,
    pub symbol: String,
    pub amount: Decimal,
    pub staked_at: DateTime<Utc>,
    pub apy: f32,
}

#[derive(Default)]
pub struct StakingEngine {
    pub stakes: Vec<StakeInfo>,
    pub supported: HashMap<String, f32>, // symbol -> APY
}

impl StakingEngine {
    pub fn add_supported(&mut self, symbol: &str, apy: f32) {
        self.supported.insert(symbol.to_string(), apy);
    }

    pub fn stake(&mut self, user: &str, symbol: &str, amount: Decimal) -> Result<(), String> {
        let apy = *self.supported.get(symbol).ok_or("Not supported")?;
        self.stakes.push(StakeInfo {
            user: user.to_owned(),
            symbol: symbol.to_owned(),
            amount,
            staked_at: Utc::now(),
            apy,
        });
        Ok(())
    }

    pub fn calculate_rewards(&self, user: &str, symbol: &str) -> Decimal {
        let mut total = Decimal::ZERO;
        for s in self.stakes.iter().filter(|x| x.user == user && x.symbol == symbol) {
            let duration = (Utc::now() - s.staked_at).num_days() as f32 / 365.0;
            let reward = s.amount * Decimal::from_f32((s.apy / 100.0) * duration).unwrap_or(Decimal::ZERO);
            total += reward;
        }
        total
    }
}