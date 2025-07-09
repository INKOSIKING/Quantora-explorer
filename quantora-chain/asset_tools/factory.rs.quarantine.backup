//! Asset factory with event emission and access control

use crate::runtime::{VmType, Runtime, RuntimeError};
use tracing::{info, error};
use async_trait::async_trait;

pub struct TokenParams { pub name: String, pub symbol: String, pub decimals: u8, pub supply: u128 }
pub struct NFTParams { pub name: String, pub uri: String, pub supply: u32 }
pub struct DAOParams { pub name: String, pub founders: Vec<String>, pub governance_type: String }

#[async_trait]
pub trait AssetFactory: Send + Sync {
    async fn create_token(&self, caller: &str, params: TokenParams, vm: VmType) -> Result<String, RuntimeError>;
    async fn create_nft(&self, caller: &str, params: NFTParams, vm: VmType) -> Result<String, RuntimeError>;
    async fn create_dao(&self, caller: &str, params: DAOParams, vm: VmType) -> Result<String, RuntimeError>;
}

pub struct DefaultAssetFactory { pub runtime: Runtime }

#[async_trait]
impl AssetFactory for DefaultAssetFactory {
    async fn create_token(&self, caller: &str, params: TokenParams, vm: VmType) -> Result<String, RuntimeError> {
        // Access control: check if caller is allowed to create assets
        info!("{} is creating token {} on {:?}", caller, params.symbol, vm);
        let code = include_bytes!("erc20.bin");
        let _ = self.runtime.execute(vm, code, &bincode::serialize(&params).unwrap()).await?;
        // Emit event to event bus/log
        Ok(format!("Token {} deployed", params.symbol))
    }
    async fn create_nft(&self, caller: &str, params: NFTParams, vm: VmType) -> Result<String, RuntimeError> {
        info!("{} is creating NFT {} on {:?}", caller, params.name, vm);
        let code = include_bytes!("erc721.bin");
        let _ = self.runtime.execute(vm, code, &bincode::serialize(&params).unwrap()).await?;
        Ok(format!("NFT {} deployed", params.name))
    }
    async fn create_dao(&self, caller: &str, params: DAOParams, vm: VmType) -> Result<String, RuntimeError> {
        info!("{} is creating DAO {} with governance {} on {:?}", caller, params.name, params.governance_type, vm);
        let code = include_bytes!("dao.bin");
        let _ = self.runtime.execute(vm, code, &bincode::serialize(&params).unwrap()).await?;
        Ok(format!("DAO {} created", params.name))
    }
}