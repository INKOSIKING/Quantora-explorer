//! Validator set with rotation, event logging, and secure slashing

use std::collections::HashMap;
use tracing::{info, warn};

#[derive(Clone, Debug)]
pub struct Validator {
    pub address: String,
    pub stake: u128,
    pub active: bool,
    pub missed_blocks: u32,
}

#[derive(Default)]
pub struct ValidatorSet {
    pub validators: HashMap<String, Validator>,
    pub min_stake: u128,
}

impl ValidatorSet {
    pub fn add(&mut self, validator: Validator) {
        if validator.stake >= self.min_stake {
            info!("Validator {} added", validator.address);
            self.validators.insert(validator.address.clone(), validator);
        } else {
            warn!("Validator {} below min stake", validator.address);
        }
    }
    pub fn remove(&mut self, address: &str) {
        self.validators.remove(address);
        info!("Validator {} removed", address);
    }
    pub fn rotate(&mut self) {
        for v in self.validators.values_mut() {
            if v.missed_blocks > 10 {
                v.active = false;
                warn!("Validator {} set inactive for missed blocks", v.address);
            }
        }
    }
    pub fn get_mut(&mut self, address: &str) -> Option<&mut Validator> {
        self.validators.get_mut(address)
    }
}

pub struct Slashing;

impl Slashing {
    pub fn slash(&self, validator: &mut Validator, amount: u128) {
        validator.stake = validator.stake.saturating_sub(amount);
        if validator.stake < 1 {
            validator.active = false;
            warn!("Validator {} slashed to zero, deactivated", validator.address);
        } else {
            info!("Validator {} slashed by {}", validator.address, amount);
        }
    }
}