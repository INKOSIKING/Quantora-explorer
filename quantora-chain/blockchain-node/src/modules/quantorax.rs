//! QuantoraX DEX module (AMM + orderbook hybrid)

use frame_support::{pallet_prelude::*, dispatch::DispatchResult};
use frame_system::pallet_prelude::*;

#[frame_support::pallet]
pub mod quantorax {
    use super::*;

    #[pallet::config]
    pub trait Config: frame_system::Config {
        type Event: From<Event<Self>> + IsType<<Self as frame_system::Config>::Event>;
    }

    #[pallet::storage]
    #[pallet::getter(fn pools)]
    pub type Pools<T: Config> = StorageMap<_, Blake2_128Concat, (u32, u32), (u128, u128), OptionQuery>;

    #[pallet::event]
    pub enum Event<T: Config> {
        Swap(u32, u32, T::AccountId, u128, u128),
        PoolCreated(u32, u32),
    }

    #[pallet::pallet]
    pub struct Pallet<T>(_);

    #[pallet::call]
    impl<T: Config> Pallet<T> {
        #[pallet::weight(10_000)]
        pub fn create_pool(origin: OriginFor<T>, token_a: u32, token_b: u32) -> DispatchResult {
            let _ = ensure_signed(origin)?;
            ensure!(Pools::<T>::get((token_a, token_b)).is_none(), "Pool exists");
            Pools::<T>::insert((token_a, token_b), (0, 0));
            Self::deposit_event(Event::PoolCreated(token_a, token_b));
            Ok(())
        }

        #[pallet::weight(10_000)]
        pub fn swap(origin: OriginFor<T>, token_a: u32, token_b: u32, amount_in: u128) -> DispatchResult {
            let who = ensure_signed(origin)?;
            let (reserve_a, reserve_b) = Pools::<T>::get((token_a, token_b)).ok_or("No pool")?;
            // AMM logic: constant product, fee, slippage etc
            let amount_out = amount_in * reserve_b / (reserve_a + amount_in); // Simplified
            Pools::<T>::mutate((token_a, token_b), |r| {
                if let Some((ra, rb)) = r {
                    *ra += amount_in;
                    *rb -= amount_out;
                }
            });
            Self::deposit_event(Event::Swap(token_a, token_b, who, amount_in, amount_out));
            Ok(())
        }
    }
}