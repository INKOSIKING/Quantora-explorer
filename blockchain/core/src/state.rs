
use std::collections::HashMap;

pub struct State {
    pub balances: HashMap<String, u64>,
}

impl State {
    pub fn new() -> Self {
        Self {
            balances: HashMap::new(),
        }
    }
}

