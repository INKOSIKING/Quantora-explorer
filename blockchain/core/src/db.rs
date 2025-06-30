use crate::models::{Account, Transaction, Block};
use sqlx::{PgPool, Row};
use uuid::Uuid;
use chrono::Utc;

pub async fn get_account(pool: &PgPool, address: &str) -> sqlx::Result<Option<Account>> {
    sqlx::query_as::<_, Account>("SELECT * FROM accounts WHERE address = $1")
        .bind(address)
        .fetch_optional(pool)
        .await
}

pub async fn create_account(pool: &PgPool, address: &str) -> sqlx::Result<Account> {
    let id = Uuid::new_v4();
    let now = Utc::now();
    sqlx::query_as::<_, Account>(
        "INSERT INTO accounts (id, address, balance, created_at) VALUES ($1, $2, 0, $3) RETURNING *"
    )
    .bind(id)
    .bind(address)
    .bind(now)
    .fetch_one(pool)
    .await
}

pub async fn update_account_balance(pool: &PgPool, address: &str, balance: i64) -> sqlx::Result<()> {
    sqlx::query("UPDATE accounts SET balance = $1 WHERE address = $2")
        .bind(balance)
        .bind(address)
        .execute(pool)
        .await?;
    Ok(())
}

pub async fn insert_transaction(pool: &PgPool, tx: &Transaction) -> sqlx::Result<()> {
    sqlx::query(
        "INSERT INTO transactions (id, from, to, amount, nonce, block_hash, signature, timestamp, status) VALUES \
         ($1, $2, $3, $4, $5, $6, $7, $8, $9)"
    )
    .bind(tx.id)
    .bind(&tx.from)
    .bind(&tx.to)
    .bind(tx.amount)
    .bind(tx.nonce)
    .bind(&tx.block_hash)
    .bind(&tx.signature)
    .bind(tx.timestamp)
    .bind(&tx.status)
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn get_pending_transactions(pool: &PgPool) -> sqlx::Result<Vec<Transaction>> {
    sqlx::query_as::<_, Transaction>("SELECT * FROM transactions WHERE status = 'pending'")
        .fetch_all(pool)
        .await
}

pub async fn confirm_transaction(pool: &PgPool, tx_id: Uuid, block_hash: &str) -> sqlx::Result<()> {
    sqlx::query("UPDATE transactions SET status = 'confirmed', block_hash = $1 WHERE id = $2")
        .bind(block_hash)
        .bind(tx_id)
        .execute(pool)
        .await?;
    Ok(())
}

pub async fn insert_block(pool: &PgPool, block: &Block) -> sqlx::Result<()> {
    sqlx::query(
        "INSERT INTO blocks (id, hash, prev_hash, height, timestamp) VALUES ($1, $2, $3, $4, $5)"
    )
    .bind(block.id)
    .bind(&block.hash)
    .bind(&block.prev_hash)
    .bind(block.height)
    .bind(block.timestamp)
    .execute(pool)
    .await?;
    Ok(())
}

pub async fn get_last_block(pool: &PgPool) -> sqlx::Result<Option<Block>> {
    sqlx::query_as::<_, Block>("SELECT * FROM blocks ORDER BY height DESC LIMIT 1")
        .fetch_optional(pool)
        .await
}
use sqlx::{PgPool, Row};
use uuid::Uuid;
use crate::models::*;
use crate::error::BlockchainError;

pub struct Database {
    pool: PgPool,
}

impl Database {
    pub fn new(pool: PgPool) -> Self {
        Self { pool }
    }
    
    // User operations
    pub async fn create_user(&self, user: &User) -> Result<(), BlockchainError> {
        sqlx::query!(
            "INSERT INTO users (id, username, email, password_hash, wallet_address, created_at, updated_at) 
             VALUES ($1, $2, $3, $4, $5, $6, $7)",
            user.id,
            user.username,
            user.email,
            user.password_hash,
            user.wallet_address,
            user.created_at,
            user.updated_at
        )
        .execute(&self.pool)
        .await?;
        
        Ok(())
    }
    
    pub async fn get_user_by_username(&self, username: &str) -> Result<Option<User>, BlockchainError> {
        let user = sqlx::query_as!(
            User,
            "SELECT * FROM users WHERE username = $1",
            username
        )
        .fetch_optional(&self.pool)
        .await?;
        
        Ok(user)
    }
    
    // Block operations
    pub async fn create_block(&self, block: &Block) -> Result<(), BlockchainError> {
        sqlx::query!(
            "INSERT INTO blocks (id, index, hash, previous_hash, timestamp, nonce, merkle_root, difficulty, created_at)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)",
            block.id,
            block.index,
            block.hash,
            block.previous_hash,
            block.timestamp,
            block.nonce,
            block.merkle_root,
            block.difficulty,
            block.created_at
        )
        .execute(&self.pool)
        .await?;
        
        Ok(())
    }
    
    pub async fn get_latest_block(&self) -> Result<Option<Block>, BlockchainError> {
        let block = sqlx::query_as!(
            Block,
            "SELECT * FROM blocks ORDER BY index DESC LIMIT 1"
        )
        .fetch_optional(&self.pool)
        .await?;
        
        Ok(block)
    }
    
    pub async fn get_block_by_hash(&self, hash: &str) -> Result<Option<Block>, BlockchainError> {
        let block = sqlx::query_as!(
            Block,
            "SELECT * FROM blocks WHERE hash = $1",
            hash
        )
        .fetch_optional(&self.pool)
        .await?;
        
        Ok(block)
    }
    
    // Transaction operations
    pub async fn create_transaction(&self, tx: &Transaction) -> Result<(), BlockchainError> {
        sqlx::query!(
            "INSERT INTO transactions (id, hash, from_address, to_address, amount, fee, signature, timestamp, block_id, status, created_at)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
            tx.id,
            tx.hash,
            tx.from_address,
            tx.to_address,
            tx.amount,
            tx.fee,
            tx.signature,
            tx.timestamp,
            tx.block_id,
            tx.status as TransactionStatus,
            tx.created_at
        )
        .execute(&self.pool)
        .await?;
        
        Ok(())
    }
    
    pub async fn get_pending_transactions(&self) -> Result<Vec<Transaction>, BlockchainError> {
        let transactions = sqlx::query_as!(
            Transaction,
            "SELECT * FROM transactions WHERE status = 'pending' ORDER BY created_at ASC"
        )
        .fetch_all(&self.pool)
        .await?;
        
        Ok(transactions)
    }
    
    pub async fn get_balance(&self, address: &str) -> Result<i64, BlockchainError> {
        let result = sqlx::query!(
            "SELECT 
                COALESCE(SUM(CASE WHEN to_address = $1 THEN amount ELSE 0 END), 0) -
                COALESCE(SUM(CASE WHEN from_address = $1 THEN amount + fee ELSE 0 END), 0) as balance
             FROM transactions 
             WHERE (from_address = $1 OR to_address = $1) AND status = 'confirmed'",
            address
        )
        .fetch_one(&self.pool)
        .await?;
        
        Ok(result.balance.unwrap_or(0))
    }
    
    pub async fn update_transaction_status(
        &self, 
        tx_id: Uuid, 
        status: TransactionStatus,
        block_id: Option<Uuid>
    ) -> Result<(), BlockchainError> {
        sqlx::query!(
            "UPDATE transactions SET status = $1, block_id = $2 WHERE id = $3",
            status as TransactionStatus,
            block_id,
            tx_id
        )
        .execute(&self.pool)
        .await?;
        
        Ok(())
    }
}
