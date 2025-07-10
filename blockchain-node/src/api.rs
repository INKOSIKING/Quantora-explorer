
use crate::blockchain::Blockchain;
use std::sync::{Arc, Mutex};
use warp::Filter;
use serde::{Deserialize, Serialize};

#[derive(Serialize)]
struct StatusResponse {
    status: String,
    blocks: usize,
    difficulty: usize,
    total_supply: String,
    mining_pool: String,
}

#[derive(Serialize)]
struct BalanceResponse {
    address: String,
    balance: String,
}

#[derive(Deserialize)]
struct TransactionRequest {
    from: String,
    to: String,
    amount: u64,
}

#[derive(Serialize)]
struct TransactionResponse {
    success: bool,
    message: String,
    tx_hash: Option<String>,
}

pub async fn run_api_server(blockchain: Arc<Mutex<Blockchain>>) {
    let blockchain_filter = warp::any().map(move || blockchain.clone());

    let status = warp::path("status")
        .and(warp::get())
        .and(blockchain_filter.clone())
        .map(|blockchain: Arc<Mutex<Blockchain>>| {
            let chain = blockchain.lock().unwrap();
            let stats = chain.get_blockchain_stats();
            warp::reply::json(&StatusResponse {
                status: "running".to_string(),
                blocks: chain.chain.len(),
                difficulty: chain.difficulty,
                total_supply: stats.get("total_supply").unwrap_or(&"0".to_string()).clone(),
                mining_pool: stats.get("mining_pool").unwrap_or(&"0".to_string()).clone(),
            })
        });

    let balance = warp::path!("balance" / String)
        .and(warp::get())
        .and(blockchain_filter.clone())
        .map(|address: String, blockchain: Arc<Mutex<Blockchain>>| {
            let chain = blockchain.lock().unwrap();
            let balance = chain.get_balance(&address);
            warp::reply::json(&BalanceResponse {
                address,
                balance: balance.to_string(),
            })
        });

    let chain_info = warp::path("chain")
        .and(warp::get())
        .and(blockchain_filter.clone())
        .map(|blockchain: Arc<Mutex<Blockchain>>| {
            let chain = blockchain.lock().unwrap();
            warp::reply::json(&chain.chain)
        });

    let routes = status.or(balance).or(chain_info);

    println!("🌐 API server starting on 0.0.0.0:8080");
    warp::serve(routes)
        .run(([0, 0, 0, 0], 8080))
        .await;
}
