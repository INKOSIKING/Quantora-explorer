pub mod token;
pub mod nft;
pub mod dao;
pub mod factory;
pub mod interface;

use token::{TokenFactory, TokenConfig};
use nft::{NftFactory, NftConfig};
use dao::{DaoFactory, DaoConfig};
use interface::{CreatorResult, CreatorError};

pub struct CreatorHub {
    pub token_factory: TokenFactory,
    pub nft_factory: NftFactory,
    pub dao_factory: DaoFactory,
}

impl CreatorHub {
    pub fn new() -> Self {
        Self {
            token_factory: TokenFactory::default(),
            nft_factory: NftFactory::default(),
            dao_factory: DaoFactory::default(),
        }
    }

    pub fn create_token(&self, cfg: &TokenConfig) -> Result<CreatorResult, CreatorError> {
        self.token_factory.create(cfg)
    }

    pub fn create_nft(&self, cfg: &NftConfig) -> Result<CreatorResult, CreatorError> {
        self.nft_factory.create(cfg)
    }

    pub fn create_dao(&self, cfg: &DaoConfig) -> Result<CreatorResult, CreatorError> {
        self.dao_factory.create(cfg)
    }
}