use super::interface::{Validator, ValidatorEvent};

#[derive(Debug, Clone)]
pub enum SlashingReason {
    DoubleSigning,
    Downtime,
    InvalidVote,
    Cheating,
    Custom(String),
}

#[derive(Default)]
pub struct SlashingEngine {
    pub slashed: Vec<(Validator, String)>,
}

impl SlashingEngine {
    pub fn slash(&mut self, validator: &Validator, reason: SlashingReason) -> bool {
        let reason_str = match &reason {
            SlashingReason::DoubleSigning => "Double signing".to_string(),
            SlashingReason::Downtime => "Downtime".to_string(),
            SlashingReason::InvalidVote => "Invalid vote".to_string(),
            SlashingReason::Cheating => "Cheating".to_string(),
            SlashingReason::Custom(s) => s.clone(),
        };
        self.slashed.push((validator.clone(), reason_str.clone()));
        println!(
            "Validator {} slashed for reason: {}",
            validator.address, reason_str
        );
        true
    }
}