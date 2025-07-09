use thiserror::Error;

#[derive(Error, Debug)]
pub enum IndexerError {
    #[error("db error: {0}")]
    Db(#[from] sqlx::Error),
    #[error("blockchain API error")]
    BlockchainApi,
    #[error("internal error")]
    Internal,
}
