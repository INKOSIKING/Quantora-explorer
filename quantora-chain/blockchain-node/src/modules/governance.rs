//! On-chain governance module (proposals, voting, execution)

use frame_support::{pallet_prelude::*, dispatch::DispatchResult};
use frame_system::pallet_prelude::*;

#[frame_support::pallet]
pub mod governance {
    use super::*;

    #[pallet::config]
    pub trait Config: frame_system::Config {
        type Event: From<Event<Self>> + IsType<<Self as frame_system::Config>::Event>;
    }

    #[pallet::storage]
    #[pallet::getter(fn proposals)]
    pub type Proposals<T: Config> = StorageMap<_, Blake2_128Concat, u32, Vec<u8>, OptionQuery>;

    #[pallet::storage]
    #[pallet::getter(fn votes)]
    pub type Votes<T: Config> = StorageDoubleMap<_, Blake2_128Concat, u32, Blake2_128Concat, T::AccountId, bool, OptionQuery>;

    #[pallet::event]
    pub enum Event<T: Config> {
        ProposalSubmitted(u32, Vec<u8>),
        Voted(u32, T::AccountId, bool),
        ProposalExecuted(u32),
    }

    #[pallet::pallet]
    pub struct Pallet<T>(_);

    #[pallet::call]
    impl<T: Config> Pallet<T> {
        #[pallet::weight(10_000)]
        pub fn propose(origin: OriginFor<T>, proposal: Vec<u8>) -> DispatchResult {
            let who = ensure_signed(origin)?;
            let id = sp_io::hashing::blake2_128(&proposal)[0] as u32; // Simple id for demo
            <Proposals<T>>::insert(id, proposal.clone());
            Self::deposit_event(Event::ProposalSubmitted(id, proposal));
            Ok(())
        }

        #[pallet::weight(10_000)]
        pub fn vote(origin: OriginFor<T>, id: u32, approve: bool) -> DispatchResult {
            let who = ensure_signed(origin)?;
            <Votes<T>>::insert(id, who.clone(), approve);
            Self::deposit_event(Event::Voted(id, who, approve));
            Ok(())
        }

        #[pallet::weight(10_000)]
        pub fn execute(origin: OriginFor<T>, id: u32) -> DispatchResult {
            let _ = ensure_root(origin)?;
            // In production, check votes/quorum before execution
            <Proposals<T>>::remove(id);
            Self::deposit_event(Event::ProposalExecuted(id));
            Ok(())
        }
    }
}