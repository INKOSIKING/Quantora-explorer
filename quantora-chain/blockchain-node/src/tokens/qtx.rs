//! QTX (Quantora Token) implementation - robust, upgradeable

use frame_support::{pallet_prelude::*, traits::Currency, dispatch::DispatchResult};
use frame_system::pallet_prelude::*;

#[frame_support::pallet]
pub mod qtx {
    use super::*;

    #[pallet::config]
    pub trait Config: frame_system::Config {
        type Event: From<Event<Self>> + IsType<<Self as frame_system::Config>::Event>;
        type Currency: Currency<Self::AccountId>;
    }

    #[pallet::storage]
    #[pallet::getter(fn total_supply)]
    pub type TotalSupply<T: Config> = StorageValue<_, u128, ValueQuery>;

    #[pallet::event]
    #[pallet::generate_deposit(pub(super) fn deposit_event)]
    pub enum Event<T: Config> {
        Minted(T::AccountId, u128),
        Burned(T::AccountId, u128),
        Transferred(T::AccountId, T::AccountId, u128),
    }

    #[pallet::error]
    pub enum Error<T> {
        InsufficientBalance,
    }

    #[pallet::pallet]
    pub struct Pallet<T>(_);

    #[pallet::call]
    impl<T: Config> Pallet<T> {
        #[pallet::weight(10_000)]
        pub fn mint(origin: OriginFor<T>, to: T::AccountId, amount: u128) -> DispatchResult {
            let _ = ensure_root(origin)?;
            <TotalSupply<T>>::mutate(|v| *v += amount);
            T::Currency::deposit_creating(&to, amount);
            Self::deposit_event(Event::Minted(to, amount));
            Ok(())
        }

        #[pallet::weight(10_000)]
        pub fn burn(origin: OriginFor<T>, from: T::AccountId, amount: u128) -> DispatchResult {
            let _ = ensure_root(origin)?;
            T::Currency::withdraw(&from, amount, frame_support::traits::WithdrawReasons::TRANSFER, Default::default())?;
            <TotalSupply<T>>::mutate(|v| *v -= amount);
            Self::deposit_event(Event::Burned(from, amount));
            Ok(())
        }

        #[pallet::weight(10_000)]
        pub fn transfer(origin: OriginFor<T>, to: T::AccountId, amount: u128) -> DispatchResult {
            let from = ensure_signed(origin)?;
            T::Currency::transfer(&from, &to, amount, frame_support::traits::ExistenceRequirement::AllowDeath)?;
            Self::deposit_event(Event::Transferred(from, to, amount));
            Ok(())
        }
    }
}