pub mod indexer;
pub mod query_engine;
pub mod dsl;
pub mod schema;
pub mod runtime;

use indexer::ChainIndexer;
use query_engine::QueryEngine;
use dsl::QueryDSL;
use schema::{SchemaRegistry, SchemaDef};

pub struct IndexingLayer {
    pub indexer: ChainIndexer,
    pub engine: QueryEngine,
    pub schema: SchemaRegistry,
}

impl IndexingLayer {
    pub fn new() -> Self {
        let schema = SchemaRegistry::default();
        Self {
            indexer: ChainIndexer::new(schema.clone()),
            engine: QueryEngine::new(schema.clone()),
            schema,
        }
    }

    pub fn index_block(&mut self, block_bytes: &[u8]) {
        self.indexer.index_block(block_bytes)
    }

    pub fn execute_query(&self, dsl_query: &str) -> Result<String, String> {
        let q = QueryDSL::parse(dsl_query, &self.schema)?;
        self.engine.execute(&q)
    }
}