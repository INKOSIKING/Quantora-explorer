use chrono::Utc;
use std::collections::HashMap;

pub struct FreezeManager {
    pub frozen_accounts: HashMap<String, String>, // user_id -> reason
}

impl FreezeManager {
    pub fn new() -> Self {
        FreezeManager { frozen_accounts: HashMap::new() }
    }
    pub fn freeze(&mut self, user_id: &str, reason: &str) {
        self.frozen_accounts.insert(user_id.to_owned(), reason.to_owned());
        // Log event, alert compliance
    }
    pub fn unfreeze(&mut self, user_id: &str) {
        self.frozen_accounts.remove(user_id);
    }
    pub fn is_frozen(&self, user_id: &str) -> bool {
        self.frozen_accounts.contains_key(user_id)
    }
    pub fn check_before_withdraw(&self, user_id: &str) -> Result<(), String> {
        if self.is_frozen(user_id) {
            Err(format!("Account {} is frozen: {}", user_id, self.frozen_accounts[user_id]))
        } else {
            Ok(())
        }
    }
}