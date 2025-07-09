use thiserror::Error;

#[derive(Error, Debug)]
pub enum BlockchainError {
    #[error("db error: {0}")]
    Db(#[from] sqlx::Error),
    #[error("invalid address")]
    InvalidAddress,
    #[error("insufficient balance")]
    InsufficientBalance,
    #[error("transaction not found")]
    TxNotFound,
    #[error("internal error")]
    Internal,
}