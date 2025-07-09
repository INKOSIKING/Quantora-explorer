use codec::{Encode, Decode};
use sp_std::prelude::*;
use sp_runtime::RuntimeDebug;

#[derive(Encode, Decode, Clone, PartialEq, Eq, RuntimeDebug)]
pub struct Proposal {
    pub proposer: [u8; 32],
    pub call: Vec<u8>,
    pub votes_for: u32,
    pub votes_against: u32,
    pub executed: bool,
}

pub trait Trait: frame_system::Trait {}

decl_storage! {
    trait Store for Module<T: Trait> as Governance {
        Proposals get(fn proposals): map hasher(identity) u32 => Option<Proposal>;
        ProposalCount get(fn proposal_count): u32;
    }
}

decl_event!(
    pub enum Event {
        ProposalSubmitted(u32),
        Voted(u32, bool),
        Executed(u32),
    }
);

decl_module! {
    pub struct Module<T: Trait> for enum Call where origin: T::Origin {
        fn submit_proposal(origin, call: Vec<u8>) {
            let sender = ensure_signed(origin)?;
            let id = ProposalCount::get() + 1;
            let prop = Proposal {
                proposer: sender.encode().try_into().unwrap(),
                call,
                votes_for: 0,
                votes_against: 0,
                executed: false
            };
            Proposals::insert(id, prop);
            ProposalCount::put(id);
            Self::deposit_event(Event::ProposalSubmitted(id));
        }
        fn vote(origin, proposal: u32, support: bool) {
            let _ = ensure_signed(origin)?;
            Proposals::mutate(proposal, |maybe_prop| {
                if let Some(ref mut prop) = maybe_prop {
                    if support { prop.votes_for += 1; }
                    else { prop.votes_against += 1; }
                }
            });
            Self::deposit_event(Event::Voted(proposal, support));
        }
        fn execute(origin, proposal: u32) {
            let _ = ensure_signed(origin)?;
            Proposals::mutate(proposal, |maybe_prop| {
                if let Some(ref mut prop) = maybe_prop {
                    if !prop.executed && prop.votes_for > prop.votes_against {
                        // Place execution logic here (dispatch the call)
                        prop.executed = true;
                        Self::deposit_event(Event::Executed(proposal));
                    }
                }
            });
        }
    }
}