//! Quadratic Voting Implementation

use std::collections::HashMap;

pub struct QuadraticVoting {
    pub votes: HashMap<u64, HashMap<String, u64>>,
}

impl QuadraticVoting {
    pub fn new() -> Self {
        QuadraticVoting {
            votes: HashMap::new(),
        }
    }

    pub fn vote(&mut self, proposal_id: u64, voter: &str, stake: u64) -> Result<(), String> {
        let power = (stake as f64).sqrt() as u64;
        self.votes
            .entry(proposal_id)
            .or_default()
            .entry(voter.to_owned())
            .and_modify(|v| *v += power)
            .or_insert(power);
        Ok(())
    }
}