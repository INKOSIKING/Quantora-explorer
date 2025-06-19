use thiserror::Error;

#[derive(Error, Debug)]
pub enum ExchangeError {
    #[error("db error: {0}")]
    Db(#[from] sqlx::Error),
    #[error("user not found")]
    UserNotFound,
    #[error("wrong password")]
    WrongPassword,
    #[error("insufficient balance")]
    InsufficientBalance,
    #[error("order not found")]
    OrderNotFound,
    #[error("internal error")]
    Internal,
}