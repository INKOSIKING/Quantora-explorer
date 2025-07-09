//! Slashing Logic for Validators

pub struct Slashing;

impl Slashing {
    pub fn slash(&self, validator: &mut super::dynamic_validator_set::Validator, amount: u128) {
        validator.stake = validator.stake.saturating_sub(amount);
        // Optionally mark as inactive, emit event, etc.
    }
}