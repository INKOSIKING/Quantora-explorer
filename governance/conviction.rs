use super::interface::{ProposalStatus, VotingOutcome, Voter};
use super::voting::VotingModule;
use crate::governance::governance_core::GovernanceCore;
use std::collections::HashMap;

#[derive(Default)]
pub struct ConvictionVotingModule {
    pub stakes: HashMap<u64, HashMap<String, (u128, u32)>>, // proposal_id -> (address -> (stake, duration))
}

impl VotingModule for ConvictionVotingModule {
    fn vote(
        &self,
        core: &mut GovernanceCore,
        proposal_id: u64,
        voter: Voter,
        stake: u128,
        duration: u32,
    ) -> Result<VotingOutcome, String> {
        let proposal = core.get_proposal_mut(proposal_id).ok_or("Proposal not found")?;
        // Conviction = stake * duration
        let conviction = stake * duration as u128;
        proposal.votes_for += conviction;
        if proposal.votes_for > 2000 {
            proposal.status = ProposalStatus::Passed;
            return Ok(VotingOutcome::Passed);
        }
        Ok(VotingOutcome::InProgress)
    }
}