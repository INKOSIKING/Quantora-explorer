//! Mining module (on-chain mining rewards, possibly PoS/aux PoW hybrid)

use frame_support::{pallet_prelude::*, dispatch::DispatchResult};
use frame_system::pallet_prelude::*;

#[frame_support::pallet]
pub mod mining {
    use super::*;

    #[pallet::config]
    pub trait Config: frame_system::Config {
        type Event: From<Event<Self>> + IsType<<Self as frame_system::Config>::Event>;
    }

    #[pallet::storage]
    #[pallet::getter(fn rewards)]
    pub type Rewards<T: Config> = StorageMap<_, Blake2_128Concat, T::AccountId, u128, ValueQuery>;

    #[pallet::event]
    pub enum Event<T: Config> {
        Rewarded(T::AccountId, u128),
    }

    #[pallet::pallet]
    pub struct Pallet<T>(_);

    #[pallet::call]
    impl<T: Config> Pallet<T> {
        #[pallet::weight(10_000)]
        pub fn claim_reward(origin: OriginFor<T>) -> DispatchResult {
            let who = ensure_signed(origin)?;
            let reward = Rewards::<T>::take(&who);
            // Mint or transfer reward to user
            Self::deposit_event(Event::Rewarded(who, reward));
            Ok(())
        }
    }
}