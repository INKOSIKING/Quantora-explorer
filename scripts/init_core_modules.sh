#!/bin/bash
# ------------------------------------------------------------------------------
# init_core_modules.sh — Initializes Quantora blockchain core Rust modules
# With structs, traits, and module headers to make code compilable and ready.
# ------------------------------------------------------------------------------

set -euo pipefail

CORE_DIR="$HOME/Quantora/blockchain/core/src"

declare -A FILE_CONTENTS

FILE_CONTENTS["network.rs"]='
pub fn init_network() {
    println!("Network initialized.");
}
'

FILE_CONTENTS["validator.rs"]='
pub struct Validator {
    pub id: String,
    pub stake: u64,
}

impl Validator {
    pub fn new(id: &str, stake: u64) -> Self {
        Self {
            id: id.to_string(),
            stake,
        }
    }
}
'

FILE_CONTENTS["mempool.rs"]='
use crate::transaction::Transaction;

pub struct Mempool {
    pub transactions: Vec<Transaction>,
}

impl Mempool {
    pub fn new() -> Self {
        Self {
            transactions: vec![],
        }
    }
}
'

FILE_CONTENTS["transaction.rs"]='
#[derive(Clone, Debug)]
pub struct Transaction {
    pub sender: String,
    pub receiver: String,
    pub amount: u64,
}

impl Transaction {
    pub fn new(sender: &str, receiver: &str, amount: u64) -> Self {
        Self {
            sender: sender.to_string(),
            receiver: receiver.to_string(),
            amount,
        }
    }
}
'

FILE_CONTENTS["consensus.rs"]='
pub fn run_consensus() {
    println!("Consensus algorithm running...");
}
'

FILE_CONTENTS["state.rs"]='
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
'

FILE_CONTENTS["storage.rs"]='
pub fn save_to_disk(data: &str) {
    println!("Saving data: {}", data);
}
'

FILE_CONTENTS["config.rs"]='
pub struct Config {
    pub chain_id: String,
    pub block_time: u64,
}
'

for file in "${!FILE_CONTENTS[@]}"; do
    DEST="$CORE_DIR/$file"
    echo "[+] Writing: $DEST"
    echo "${FILE_CONTENTS[$file]}" > "$DEST"
done

echo "✅ Core module files populated successfully."
