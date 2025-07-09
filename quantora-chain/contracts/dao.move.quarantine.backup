module 0x1::QuantoraDAO {
    use std::signer;
    use std::vector;
    use std::string;
    use std::option::{Self, Option};
    use std::table;

    /// DAO Proposal structure
    struct Proposal has store, drop, key {
        id: u64,
        title: string::String,
        description: string::String,
        yes_votes: u64,
        no_votes: u64,
        creator: address,
        executed: bool,
    }

    struct DAO has key, store {
        proposals: table::Table<u64, Proposal>,
        next_id: u64,
    }

    public fun initialize(account: &signer) {
        let dao = DAO {
            proposals: table::new<u64, Proposal>(),
            next_id: 1,
        };
        move_to(account, dao);
    }

    /// Propose a new DAO action
    public fun propose(account: &signer, title: string::String, description: string::String) {
        let addr = signer::address_of(account);
        let dao = borrow_global_mut<DAO>(addr);
        let proposal = Proposal {
            id: dao.next_id,
            title,
            description,
            yes_votes: 0,
            no_votes: 0,
            creator: addr,
            executed: false,
        };
        table::add(&mut dao.proposals, dao.next_id, proposal);
        dao.next_id = dao.next_id + 1;
    }

    /// Vote on a proposal
    public fun vote(account: &signer, proposal_id: u64, approve: bool) {
        let addr = signer::address_of(account);
        let dao = borrow_global_mut<DAO>(addr);
        let opt = table::borrow_mut(&mut dao.proposals, proposal_id);
        match opt {
            Option::Some(ref mut proposal) => {
                if (approve) {
                    proposal.yes_votes = proposal.yes_votes + 1;
                } else {
                    proposal.no_votes = proposal.no_votes + 1;
                }
            }
            Option::None => {
                // Proposal does not exist
                assert!(false, 1001);
            }
        }
    }

    /// Execute a proposal if it has more yes than no votes
    public fun execute(account: &signer, proposal_id: u64) {
        let addr = signer::address_of(account);
        let dao = borrow_global_mut<DAO>(addr);
        let opt = table::borrow_mut(&mut dao.proposals, proposal_id);
        match opt {
            Option::Some(ref mut proposal) => {
                assert!(!proposal.executed, 1002);
                if (proposal.yes_votes > proposal.no_votes) {
                    proposal.executed = true;
                    // Place custom logic here for proposal execution
                } else {
                    assert!(false, 1003);
                }
            }
            Option::None => {
                assert!(false, 1001);
            }
        }
    }
}