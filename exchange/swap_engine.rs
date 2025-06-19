//! Swap Engine: Trade any asset to QTA, USDT, BTC, ETH, etc. (routing, pricing)

use crate::exchange::asset_registry::AssetRegistry;
use rust_decimal::Decimal;
use std::collections::HashMap;

#[derive(Debug, Clone)]
pub enum SwapError {
    AssetNotFound,
    InsufficientLiquidity,
    PriceFetchFailed,
}

pub struct SwapEngine<'a> {
    pub registry: &'a AssetRegistry,
    pub pairs: HashMap<(String, String), Decimal>, // (from, to) -> price
}

impl<'a> SwapEngine<'a> {
    // Update pricing from price feeds (onchain or offchain)
    pub async fn update_prices(&mut self) {
        // Fetch prices from CoinGecko or on-chain oracles
        // Populate self.pairs
    }

    // Swap assets: returns amount of "to" asset received
    pub async fn swap(
        &self,
        from: &str,
        to: &str,
        amount: Decimal,
    ) -> Result<Decimal, SwapError> {
        let price = self.pairs.get(&(from.to_string(), to.to_string())).ok_or(SwapError::PriceFetchFailed)?;
        Ok(amount * *price)
    }
}