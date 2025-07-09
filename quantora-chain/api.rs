//! Quantora API: REST/gRPC/GraphQL endpoints for exchange, wallet, DeFi, and core chain

use axum::{
    extract::{State, Json, Path},
    routing::{post, get},
    response::{IntoResponse, Response},
    http::StatusCode,
    Router, Extension,
};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use crate::supernode::QuantoraSuperNode;
use rust_decimal::Decimal;

// --- Request/Response DTOs ---

#[derive(Deserialize)]
pub struct SwapRequest {
    pub user: String,
    pub from: String,
    pub to: String,
    pub amount: Decimal,
}

#[derive(Serialize)]
pub struct SwapResponse {
    pub received: Decimal,
}

#[derive(Deserialize)]
pub struct StakeRequest {
    pub user: String,
    pub symbol: String,
    pub amount: Decimal,
}

#[derive(Serialize)]
pub struct StakeResponse {
    pub success: bool,
}

#[derive(Deserialize)]
pub struct BalanceRequest {
    pub user: String,
    pub symbol: String,
}

#[derive(Serialize)]
pub struct BalanceResponse {
    pub balance: Decimal,
}

#[derive(Deserialize)]
pub struct WalletAddrRequest {
    pub user: String,
    pub symbol: String,
}

#[derive(Serialize)]
pub struct WalletAddrResponse {
    pub address: Option<String>,
}

#[derive(Serialize)]
pub struct AssetListResponse {
    pub assets: Vec<String>,
}

// --- Axum API handlers ---

async fn swap_handler(
    Extension(node): Extension<Arc<QuantoraSuperNode>>,
    Json(req): Json<SwapRequest>,
) -> impl IntoResponse {
    match node.swap_assets(&req.user, &req.from, &req.to, req.amount).await {
        Ok(received) => (StatusCode::OK, Json(SwapResponse { received })),
        Err(e) => (StatusCode::BAD_REQUEST, e).into_response()
    }
}

async fn stake_handler(
    Extension(node): Extension<Arc<QuantoraSuperNode>>,
    Json(req): Json<StakeRequest>,
) -> impl IntoResponse {
    match node.stake_asset(&req.user, &req.symbol, req.amount).await {
        Ok(_) => (StatusCode::OK, Json(StakeResponse { success: true })),
        Err(e) => (StatusCode::BAD_REQUEST, e).into_response()
    }
}

async fn balance_handler(
    Extension(node): Extension<Arc<QuantoraSuperNode>>,
    Json(req): Json<BalanceRequest>,
) -> impl IntoResponse {
    let balance = node.user_balance(&req.user, &req.symbol).await;
    (StatusCode::OK, Json(BalanceResponse { balance }))
}

async fn wallet_addr_handler(
    Extension(node): Extension<Arc<QuantoraSuperNode>>,
    Json(req): Json<WalletAddrRequest>,
) -> impl IntoResponse {
    let address = node.user_asset_wallet_addr(&req.user, &req.symbol).await;
    (StatusCode::OK, Json(WalletAddrResponse { address }))
}

async fn assets_handler(
    Extension(node): Extension<Arc<QuantoraSuperNode>>
) -> impl IntoResponse {
    let assets = node.asset_registry.pool
        .fetch_all(sqlx::query!("SELECT symbol FROM assets"))
        .await
        .unwrap()
        .into_iter()
        .map(|r| r.symbol)
        .collect();
    (StatusCode::OK, Json(AssetListResponse { assets }))
}

// --- API Server ---

pub async fn serve_api(node: Arc<QuantoraSuperNode>, addr: &str) {
    let app = Router::new()
        .route("/swap", post(swap_handler))
        .route("/stake", post(stake_handler))
        .route("/balance", post(balance_handler))
        .route("/wallet_addr", post(wallet_addr_handler))
        .route("/assets", get(assets_handler))
        .layer(Extension(node));

    println!("Quantora API listening on {addr}");
    axum::Server::bind(&addr.parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}