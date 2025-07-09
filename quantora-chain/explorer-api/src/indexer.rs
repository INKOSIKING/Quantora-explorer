use crate::db::DbPool;
use crate::db::{Block, Transaction};

pub struct Indexer {
    db: DbPool,
}

impl Indexer {
    pub fn new(db: DbPool) -> Self {
        Indexer { db }
    }

    // Index a new block and its transactions
    pub fn index_block(&self, block: Block, txs: Vec<Transaction>) -> Result<(), String> {
        let conn = self.db.get().map_err(|e| e.to_string())?;
        conn.immediate_transaction::<_, String, _>(|| {
            conn.execute(
                "INSERT INTO blocks (height, hash, prev_hash, timestamp, txs, nonce) VALUES (?1, ?2, ?3, ?4, ?5, ?6)",
                (&block.height, &block.hash, &block.prev_hash, &block.timestamp, &serde_json::to_string(&block.txs).unwrap(), &block.nonce)
            ).map_err(|e| e.to_string())?;

            for tx in txs {
                conn.execute(
                    "INSERT INTO transactions (hash, from_addr, to_addr, value, block_height, timestamp) VALUES (?1, ?2, ?3, ?4, ?5, ?6)",
                    (&tx.hash, &tx.from_addr, &tx.to_addr, &tx.value, &tx.block_height, &tx.timestamp)
                ).map_err(|e| e.to_string())?;
            }

            Ok(())
        })
    }
}