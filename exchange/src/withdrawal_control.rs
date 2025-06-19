use chrono::{Utc, Duration, DateTime};
use std::collections::{HashMap, HashSet};
use crate::compliance::generate_sar;

pub struct WithdrawalManager {
    pub limits: HashMap<String, f64>, // user_id -> daily limit
    pub withdrawals: HashMap<String, Vec<(DateTime<Utc>, f64)>>,
    pub whitelists: HashSet<String>, // whitelisted user_ids
}

impl WithdrawalManager {
    pub fn new() -> Self {
        WithdrawalManager {
            limits: HashMap::new(),
            withdrawals: HashMap::new(),
            whitelists: HashSet::new(),
        }
    }

    pub fn record_withdrawal(&mut self, user_id: &str, amount: f64) -> Result<(), String> {
        let now = Utc::now();
        let entry = self.withdrawals.entry(user_id.to_owned()).or_default();
        entry.push((now, amount));
        self.enforce_limits(user_id)
    }

    pub fn enforce_limits(&self, user_id: &str) -> Result<(), String> {
        let daily_limit = *self.limits.get(user_id).unwrap_or(&10000.0); // Default 10k
        let one_day_ago = Utc::now() - Duration::hours(24);
        let sum: f64 = self.withdrawals.get(user_id)
            .map(|v| v.iter().filter(|(t,_)|*t > one_day_ago).map(|(_,amt)|amt).sum())
            .unwrap_or(0.0);
        if sum > daily_limit && !self.whitelists.contains(user_id) {
            generate_sar(user_id, "Exceeded daily withdrawal limit", None);
            Err("Daily withdrawal limit exceeded".into())
        } else {
            Ok(())
        }
    }

    pub fn add_whitelist(&mut self, user_id: &str) {
        self.whitelists.insert(user_id.to_owned());
    }
}