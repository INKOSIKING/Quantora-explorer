//! Asset Registry: Sync and manage top 2000 coins from CoinGecko, create wallets on Quantora

use serde::{Deserialize, Serialize};
use sqlx::{PgPool, Error};
use reqwest::Client;
use std::collections::HashMap;

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct AssetInfo {
    pub id: String,    // coingecko id
    pub symbol: String,
    pub name: String,
    pub rank: u32,
    pub decimals: u8,
    pub logo: Option<String>,
}

pub struct AssetRegistry {
    pub pool: PgPool,
    pub client: Client,
    pub quantora_wallet_manager: crate::quantora_wallet::QuantoraWalletManager,
}

impl AssetRegistry {
    /// Sync top 2000 coins from CoinGecko and create Quantora wallets for each
    pub async fn sync_and_create_wallets(&self) -> Result<(), Error> {
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=2000&page=1";
        let resp = self.client.get(url)
            .header("accept", "application/json")
            .send().await.unwrap()
            .json::<Vec<serde_json::Value>>().await.unwrap();

        let mut new_assets = Vec::new();

        for coin in resp {
            let info = AssetInfo {
                id: coin["id"].as_str().unwrap().to_string(),
                symbol: coin["symbol"].as_str().unwrap().to_string(),
                name: coin["name"].as_str().unwrap().to_string(),
                rank: coin["market_cap_rank"].as_u64().unwrap_or(0) as u32,
                decimals: 18, // Default, can be updated via chain data as needed
                logo: coin["image"].as_str().map(|s| s.to_string()),
            };
            // Store asset in DB
            sqlx::query!(
                "INSERT INTO assets (id, symbol, name, rank, decimals, logo) VALUES ($1,$2,$3,$4,$5,$6)
                 ON CONFLICT (id) DO UPDATE SET symbol=$2, name=$3, rank=$4, decimals=$5, logo=$6",
                info.id, info.symbol, info.name, info.rank as i32, info.decimals as i16, info.logo
            ).execute(&self.pool).await?;
            new_assets.push(info);
        }

        // Create wallets for each asset on Quantora (if not already created)
        for asset in new_assets {
            self.quantora_wallet_manager.create_asset_wallet_if_needed(&asset.symbol).await;
        }
        Ok(())
    }

    pub async fn get_asset(&self, symbol: &str) -> Option<AssetInfo> {
        let row = sqlx::query_as!(AssetInfo,
            "SELECT id, symbol, name, rank, decimals, logo FROM assets WHERE symbol = $1", symbol
        ).fetch_optional(&self.pool).await.ok()?;
        row
    }
}