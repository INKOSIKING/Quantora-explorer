//! NFT module (ERC721/1155-like, on-chain metadata)

use frame_support::{pallet_prelude::*, dispatch::DispatchResult};
use frame_system::pallet_prelude::*;

#[frame_support::pallet]
pub mod nft {
    use super::*;

    #[pallet::config]
    pub trait Config: frame_system::Config {
        type Event: From<Event<Self>> + IsType<<Self as frame_system::Config>::Event>;
    }

    #[pallet::storage]
    #[pallet::getter(fn nfts)]
    pub type Nfts<T: Config> = StorageMap<_, Blake2_128Concat, u64, (T::AccountId, Vec<u8>), OptionQuery>;

    #[pallet::event]
    pub enum Event<T: Config> {
        Minted(u64, T::AccountId),
        Transferred(u64, T::AccountId, T::AccountId),
    }

    #[pallet::pallet]
    pub struct Pallet<T>(_);

    #[pallet::call]
    impl<T: Config> Pallet<T> {
        #[pallet::weight(10_000)]
        pub fn mint(origin: OriginFor<T>, id: u64, uri: Vec<u8>) -> DispatchResult {
            let who = ensure_signed(origin)?;
            ensure!(Nfts::<T>::get(id).is_none(), "NFT exists");
            Nfts::<T>::insert(id, (who.clone(), uri));
            Self::deposit_event(Event::Minted(id, who));
            Ok(())
        }

        #[pallet::weight(10_000)]
        pub fn transfer(origin: OriginFor<T>, id: u64, to: T::AccountId) -> DispatchResult {
            let who = ensure_signed(origin)?;
            let (owner, uri) = Nfts::<T>::get(id).ok_or("NFT not found")?;
            ensure!(owner == who, "Not owner");
            Nfts::<T>::insert(id, (to.clone(), uri));
            Self::deposit_event(Event::Transferred(id, who, to));
            Ok(())
        }
    }
}