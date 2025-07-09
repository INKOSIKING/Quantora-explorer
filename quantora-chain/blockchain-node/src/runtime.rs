//! Quantora Chain runtime: core blockchain logic, pallets, modules

pub use frame_support::{
    construct_runtime, parameter_types, traits::{KeyOwnerProofSystem, Randomness},
    weights::Weight,
};
pub use frame_system as system;

construct_runtime!(
    pub enum Runtime where
        Block = Block,
        NodeBlock = opaque::Block,
        UncheckedExtrinsic = UncheckedExtrinsic
    {
        System: system::{Pallet, Call, Config, Storage, Event<T>},
        Balances: pallet_balances::{Pallet, Call, Storage, Config<T>, Event<T>},
        Qtx: qtx::{Pallet, Call, Storage, Event<T>},
        Staking: staking::{Pallet, Call, Storage, Event<T>},
        Governance: governance::{Pallet, Call, Storage, Event<T>},
        Quantorax: quantorax::{Pallet, Call, Storage, Event<T>},
        Mining: mining::{Pallet, Call, Storage, Event<T>},
        Nft: nft::{Pallet, Call, Storage, Event<T>},
        Bridge: bridge::{Pallet, Call, Storage, Event<T>},
        Ai: ai::{Pallet, Call, Storage, Event<T>},
    }
);