//! Exchange API: Buy, sell, trade, orderbook, price feeds

use axum::{Router, routing::post, extract::Json, response::IntoResponse};
use serde::{Serialize, Deserialize};
use rust_decimal::Decimal;
use crate::exchange::{swap_engine::SwapEngine, wallet::UserWallet, lend_stake::StakingEngine};

#[derive(Deserialize)]
pub struct TradeRequest {
    pub user: String,
    pub from: String,
    pub to: String,
    pub amount: Decimal,
}

#[derive(Serialize)]
pub struct TradeResponse {
    pub received: Decimal,
}

async fn trade_handler(
    Json(req): Json<TradeRequest>,
    engine: axum::extract::Extension<SwapEngine<'_>>,
    wallet: axum::extract::Extension<UserWallet>,
) -> impl IntoResponse {
    // Withdraw from user wallet
    if !wallet.0.withdraw(&req.from, req.amount) {
        return (400, "Insufficient funds").into_response();
    }
    // Swap
    let received = engine.0.swap(&req.from, &req.to, req.amount).await.unwrap_or(Decimal::ZERO);
    // Deposit
    wallet.0.deposit(&req.to, received);
    Json(TradeResponse { received })
}

pub fn router(engine: SwapEngine<'static>, wallet: UserWallet, staking: StakingEngine) -> Router {
    Router::new()
        .route("/trade", post(trade_handler))
    // Extend for buy/sell/stake/lend APIs
}