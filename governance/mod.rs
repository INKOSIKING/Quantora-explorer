pub mod governance_core;
pub mod proposal;
pub mod voting;
pub mod quadratic;
pub mod conviction;
pub mod interface;

use governance_core::GovernanceCore;
use proposal::{Proposal, ProposalStatus};
use voting::{Vote, Voter, VotingOutcome};
use quadratic::QuadraticVotingModule;
use conviction::ConvictionVotingModule;

pub struct GovernanceHub {
    pub core: GovernanceCore,
    pub quadratic: QuadraticVotingModule,
    pub conviction: ConvictionVotingModule,
}

impl GovernanceHub {
    pub fn new() -> Self {
        Self {
            core: GovernanceCore::default(),
            quadratic: QuadraticVotingModule::default(),
            conviction: ConvictionVotingModule::default(),
        }
    }

    pub fn submit_proposal(&mut self, proposal: Proposal) -> Result<u64, String> {
        self.core.submit_proposal(proposal)
    }

    pub fn vote_quadratic(&mut self, proposal_id: u64, voter: Voter, weight: u128) -> Result<VotingOutcome, String> {
        self.quadratic.vote(&mut self.core, proposal_id, voter, weight)
    }

    pub fn vote_conviction(&mut self, proposal_id: u64, voter: Voter, stake: u128, duration: u32) -> Result<VotingOutcome, String> {
        self.conviction.vote(&mut self.core, proposal_id, voter, stake, duration)
    }
}