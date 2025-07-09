//! Governance with proposal lifecycle, multi-sig, and voting events

use std::collections::{HashMap, HashSet};
use thiserror::Error;
use tracing::{info, warn};

#[derive(Debug, Error)]
pub enum GovernanceError {
    #[error("Invalid vote")]
    InvalidVote,
    #[error("Proposal not found")]
    ProposalNotFound,
    #[error("Unauthorized")]
    Unauthorized,
}

#[derive(Clone, Debug)]
pub enum VotingType { Quadratic, Conviction }

#[derive(Default)]
pub struct Proposal {
    pub id: u64,
    pub title: String,
    pub description: String,
    pub submitter: String,
    pub approved: bool,
    pub votes: HashMap<String, u128>,
}

pub struct Governance {
    pub proposals: HashMap<u64, Proposal>,
    pub authorized: HashSet<String>,
}

impl Governance {
    pub fn new() -> Self {
        Self { proposals: HashMap::new(), authorized: HashSet::new() }
    }
    pub fn authorize(&mut self, user: &str) {
        self.authorized.insert(user.to_owned());
    }
    pub fn submit_proposal(&mut self, proposal: Proposal) -> Result<(), GovernanceError> {
        if !self.authorized.contains(&proposal.submitter) {
            warn!("Unauthorized proposal submission: {}", proposal.submitter);
            return Err(GovernanceError::Unauthorized);
        }
        info!("Proposal {} submitted by {}", proposal.id, proposal.submitter);
        self.proposals.insert(proposal.id, proposal);
        Ok(())
    }
    pub fn vote(&mut self, typ: VotingType, proposal_id: u64, voter: &str, stake: u64, time: Option<u64>) -> Result<(), GovernanceError> {
        let proposal = self.proposals.get_mut(&proposal_id).ok_or(GovernanceError::ProposalNotFound)?;
        let power = match typ {
            VotingType::Quadratic => (stake as f64).sqrt() as u128,
            VotingType::Conviction => (stake as u128) * (time.unwrap_or(1) as u128),
        };
        proposal.votes.entry(voter.to_owned()).and_modify(|v| *v += power).or_insert(power);
        info!("{} voted on proposal {} with power {}", voter, proposal_id, power);
        Ok(())
    }
    pub fn approve(&mut self, proposal_id: u64, threshold: u128) -> bool {
        let proposal = self.proposals.get_mut(&proposal_id).unwrap();
        let total: u128 = proposal.votes.values().copied().sum();
        if total >= threshold {
            proposal.approved = true;
            info!("Proposal {} approved!", proposal_id);
            true
        } else {
            false
        }
    }
}