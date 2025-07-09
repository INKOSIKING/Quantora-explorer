use std::time::{SystemTime, UNIX_EPOCH};
use std::collections::HashMap;

struct Sentry {
    last_seen: HashMap<String, u64>,
    threshold: u64,
}

impl Sentry {
    fn record_activity(&mut self, peer: &str) -> bool {
        let now = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs();
        let entry = self.last_seen.entry(peer.to_string()).or_insert(0);
        if now - *entry < self.threshold {
            println!("[ALERT] Peer {} is too chatty. Blocking.", peer);
            return false;
        }
        *entry = now;
        true
    }
}