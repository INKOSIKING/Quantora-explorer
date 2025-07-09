use super::{token::TokenFactory, nft::NftFactory, dao::DaoFactory};

#[derive(Default)]
pub struct MasterFactory {
    pub token: TokenFactory,
    pub nft: NftFactory,
    pub dao: DaoFactory,
}