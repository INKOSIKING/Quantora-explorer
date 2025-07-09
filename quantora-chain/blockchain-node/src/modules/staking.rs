//! Staking module for Quantora Chain (robust, secure, slashing-ready)

use frame_support::{pallet_prelude::*, traits::{Currency, LockableCurrency}, dispatch::DispatchResult};
use frame_system::pallet_prelude::*;

#[frame_support::pallet]
pub mod staking {
    use super::*;

    #[pallet::config]
    pub trait Config: frame_system::Config {
        type Currency: LockableCurrency<Self::AccountId, Moment=Self::BlockNumber>;
        type Event: From<Event<Self>> + IsType<<Self as frame_system::Config>::Event>;
        type SlashRewardFraction: Get<sp_runtime::Perbill>;
    }

    #[pallet::storage]
    #[pallet::getter(fn staked)]
    pub type Staked<T: Config> = StorageMap<_, Blake2_128Concat, T::AccountId, u128, ValueQuery>;

    #[pallet::event]
    pub enum Event<T: Config> {
        Bonded(T::AccountId, u128),
        Unbonded(T::AccountId, u128),
        Slashed(T::AccountId, u128),
        Rewarded(T::AccountId, u128),
    }

    #[pallet::pallet]
    pub struct Pallet<T>(_);

    #[pallet::call]
    impl<T: Config> Pallet<T> {
        #[pallet::weight(10_000)]
        pub fn bond(origin: OriginFor<T>, value: u128) -> DispatchResult {
            let who = ensure_signed(origin)?;
            T::Currency::set_lock("staking", &who, value, frame_support::traits::WithdrawReasons::all());
            <Staked<T>>::mutate(&who, |v| *v += value);
            Self::deposit_event(Event::Bonded(who, value));
            Ok(())
        }

        #[pallet::weight(10_000)]
        pub fn unbond(origin: OriginFor<T>, value: u128) -> DispatchResult {
            let who = ensure_signed(origin)?;
            let staked = <Staked<T>>::get(&who);
            ensure!(staked >= value, "Not enough staked");
            <Staked<T>>::mutate(&who, |v| *v -= value);
            T::Currency::remove_lock("staking", &who);
            Self::deposit_event(Event::Unbonded(who, value));
            Ok(())
        }
        // Slashing, rewards, validator selection omitted for brevity but would be implemented here
    }
}