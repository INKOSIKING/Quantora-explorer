use std::{collections::HashMap, time::{Duration, Instant}};
use tokio::sync::Mutex;
use lazy_static::lazy_static;

lazy_static! {
    static ref ABUSE_STATS: Mutex<HashMap<String, (Instant, u32)>> = Mutex::new(HashMap::new());
}

pub async fn record_api_call(ip: &str) {
    let mut abuse = ABUSE_STATS.lock().await;
    let now = Instant::now();
    let entry = abuse.entry(ip.to_owned()).or_insert((now, 0));
    if now.duration_since(entry.0) > Duration::from_secs(60) {
        entry.0 = now;
        entry.1 = 0;
    }
    entry.1 += 1;
    if entry.1 > 1000 {
        // Trigger alert, block IP, escalate
        println!("API Abuse: IP {} exceeded 1000 calls/min", ip);
    }
}