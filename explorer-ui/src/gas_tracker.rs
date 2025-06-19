use chrono::{Utc, Duration};
use std::sync::Arc;
use tokio::sync::Mutex;

pub struct GasTracker {
    pub gas_prices: Arc<Mutex<Vec<u64>>>,
}

impl GasTracker {
    pub async fn update(&self, new_price: u64) {
        let mut gp = self.gas_prices.lock().await;
        gp.push(new_price);
        if gp.len() > 1000 { gp.remove(0); }
    }
    pub async fn get_stats(&self) -> (u64, u64, u64) {
        let gp = self.gas_prices.lock().await;
        let min = *gp.iter().min().unwrap_or(&0);
        let max = *gp.iter().max().unwrap_or(&0);
        let median = if gp.is_empty() { 0 } else { gp[gp.len()/2] };
        (min, max, median)
    }
}