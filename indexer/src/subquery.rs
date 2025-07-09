//! Native Indexing & Query Language (GraphQL/SubQuery-style)

use async_graphql::{Object, Schema, Context, EmptyMutation, EmptySubscription};

pub struct QueryRoot;

#[Object]
impl QueryRoot {
    async fn block_by_number(&self, ctx: &Context<'_>, num: u64) -> Option<String> {
        // Query indexed block data
        Some(format!("Block #{}", num))
    }
    async fn tx_by_hash(&self, ctx: &Context<'_>, hash: String) -> Option<String> {
        // Query indexed transaction data
        Some(format!("Tx: {}", hash))
    }
}

// Expose schema for explorer/frontend
pub fn build_schema() -> Schema<QueryRoot, EmptyMutation, EmptySubscription> {
    Schema::build(QueryRoot, EmptyMutation, EmptySubscription).finish()
}