use chrono::{DateTime, Utc};
use std::collections::HashMap;

pub struct Stake {
    pub user_id: String,
    pub amount: f64,
    pub since: DateTime<Utc>,
}

pub struct Staking {
    pub stakes: HashMap<String, Stake>,
    pub annual_rate: f64,
}

impl Staking {
    pub fn stake(&mut self, user_id: &str, amount: f64) {
        self.stakes.insert(user_id.to_owned(), Stake {
            user_id: user_id.to_owned(),
            amount,
            since: Utc::now()
        });
    }
    pub fn calc_rewards(&self, user_id: &str) -> f64 {
        if let Some(stake) = self.stakes.get(user_id) {
            let elapsed = (Utc::now() - stake.since).num_seconds() as f64 / (365.0 * 24.0 * 3600.0);
            stake.amount * self.annual_rate * elapsed
        } else { 0.0 }
    }
}