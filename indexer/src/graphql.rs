//! Native Indexer/Query (async-graphql, production-ready)

use async_graphql::{Schema, Object, EmptyMutation, EmptySubscription, Context};
use sqlx::{PgPool};

pub struct QueryRoot;

#[Object]
impl QueryRoot {
    /// Query block by number (from SQL DB)
    async fn block_by_number(&self, ctx: &Context<'_>, number: i64) -> async_graphql::Result<String> {
        let pool = ctx.data::<PgPool>().unwrap();
        let row = sqlx::query!("SELECT hash FROM blocks WHERE number = $1", number)
            .fetch_one(pool)
            .await?;
        Ok(row.hash)
    }

    /// Query tx by hash
    async fn tx_by_hash(&self, ctx: &Context<'_>, hash: String) -> async_graphql::Result<String> {
        let pool = ctx.data::<PgPool>().unwrap();
        let row = sqlx::query!("SELECT data FROM transactions WHERE hash = $1", hash)
            .fetch_one(pool)
            .await?;
        Ok(row.data)
    }
}

pub fn build_schema(pool: PgPool) -> Schema<QueryRoot, EmptyMutation, EmptySubscription> {
    Schema::build(QueryRoot, EmptyMutation, EmptySubscription)
        .data(pool)
        .finish()
}