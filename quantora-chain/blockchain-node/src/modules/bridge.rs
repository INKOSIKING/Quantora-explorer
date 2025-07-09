//! Bridge module (cross-chain operations)

use frame_support::{pallet_prelude::*, dispatch::DispatchResult};
use frame_system::pallet_prelude::*;

#[frame_support::pallet]
pub mod bridge {
    use super::*;

    #[pallet::config]
    pub trait Config: frame_system::Config {
        type Event: From<Event<Self>> + IsType<<Self as frame_system::Config>::Event>;
    }

    #[pallet::storage]
    #[pallet::getter(fn pending_transfers)]
    pub type PendingTransfers<T: Config> = StorageMap<_, Blake2_128Concat, u64, (T::AccountId, Vec<u8>), OptionQuery>;

    #[pallet::event]
    pub enum Event<T: Config> {
        TransferInitiated(u64, T::AccountId, Vec<u8>),
        TransferCompleted(u64),
    }

    #[pallet::pallet]
    pub struct Pallet<T>(_);

    #[pallet::call]
    impl<T: Config> Pallet<T> {
        #[pallet::weight(10_000)]
        pub fn initiate_transfer(origin: OriginFor<T>, id: u64, target_chain: Vec<u8>) -> DispatchResult {
            let who = ensure_signed(origin)?;
            PendingTransfers::<T>::insert(id, (who.clone(), target_chain.clone()));
            Self::deposit_event(Event::TransferInitiated(id, who, target_chain));
            Ok(())
        }

        #[pallet::weight(10_000)]
        pub fn complete_transfer(origin: OriginFor<T>, id: u64) -> DispatchResult {
            let _ = ensure_root(origin)?;
            PendingTransfers::<T>::remove(id);
            Self::deposit_event(Event::TransferCompleted(id));
            Ok(())
        }
    }
}