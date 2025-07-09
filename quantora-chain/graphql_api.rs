//! Quantora GraphQL API: Query all wallets, assets, balances, staking

use async_graphql::{Schema, Object, EmptyMutation, EmptySubscription, Context};
use std::sync::Arc;
use crate::supernode::QuantoraSuperNode;
use rust_decimal::Decimal;

pub struct QueryRoot;

#[Object]
impl QueryRoot {
    /// Get supported asset list
    async fn assets(&self, ctx: &Context<'_>) -> async_graphql::Result<Vec<String>> {
        let node = ctx.data::<Arc<QuantoraSuperNode>>()?;
        let assets = node.asset_registry.pool
            .fetch_all(sqlx::query!("SELECT symbol FROM assets"))
            .await?
            .into_iter()
            .map(|r| r.symbol)
            .collect();
        Ok(assets)
    }

    /// Get user balance for a symbol
    async fn balance(&self, ctx: &Context<'_>, user: String, symbol: String) -> async_graphql::Result<Decimal> {
        let node = ctx.data::<Arc<QuantoraSuperNode>>()?;
        Ok(node.user_balance(&user, &symbol).await)
    }

    /// Get Quantora wallet address for user/asset
    async fn wallet_addr(&self, ctx: &Context<'_>, user: String, symbol: String) -> async_graphql::Result<Option<String>> {
        let node = ctx.data::<Arc<QuantoraSuperNode>>()?;
        Ok(node.user_asset_wallet_addr(&user, &symbol).await)
    }
}

pub fn build_schema(node: Arc<QuantoraSuperNode>) -> Schema<QueryRoot, EmptyMutation, EmptySubscription> {
    Schema::build(QueryRoot, EmptyMutation, EmptySubscription)
        .data(node)
        .finish()
}