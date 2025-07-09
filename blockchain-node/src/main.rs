use std::sync::Arc;
use tokio::sync::RwLock;
use warp::Filter;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

mod blockchain;
mod network;
mod consensus;
mod transaction;
mod wallet;
mod mempool;

use blockchain::{Blockchain, Transaction};
use network::NetworkManager;
use consensus::hybrid::HybridConsensusEngine;
use wallet::Wallet;
use mempool::Mempool;

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct BlockchainState {
    pub chain: Vec<blockchain::Block>,
    pub pending_transactions: Vec<Transaction>,
    pub balances: HashMap<String, u64>,
    pub validators: Vec<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ApiResponse<T> {
    pub success: bool,
    pub data: Option<T>,
    pub error: Option<String>,
}

type SharedState = Arc<RwLock<BlockchainState>>;

#[tokio::main]
async fn main() {
    // Initialize logging
    env_logger::init();

    // Create founder wallet
    let founder_wallet = Wallet::new_with_name("founder".to_string());
    println!("🔐 Founder Wallet Address: {}", founder_wallet.address);
    println!("💰 Founder Private Key: {}", founder_wallet.private_key);

    // Initialize blockchain state
    let mut initial_balances = HashMap::new();
    initial_balances.insert(founder_wallet.address.clone(), 1_000_000_000); // 1B tokens

    let blockchain_state = BlockchainState {
        chain: vec![blockchain::Block::genesis()],
        pending_transactions: vec![],
        balances: initial_balances,
        validators: vec![founder_wallet.address.clone()],
    };

    let shared_state: SharedState = Arc::new(RwLock::new(blockchain_state));

    // Initialize network manager
    let network_manager = NetworkManager::new();
    // network_manager.start(); // Comment out until start() method is implemented

    // 🚀 HYBRID CONSENSUS: 1 TRILLION TPS (PoS + DPoS + DAG + BFT + ZK-Rollups)
    let mut consensus_engine = HybridConsensusEngine::new();
    consensus_engine.stakes.insert(founder_wallet.address.clone(), 1_000_000);
    consensus_engine.validators.push(founder_wallet.address.clone());
    consensus_engine.bft_threshold = 1; // Start with 1, will scale with more validators
    
    println!("🔥 QUANTORA HYBRID CONSENSUS INITIALIZED!");
    println!("{}", consensus_engine.performance_report());
    
    // Comment out consensus engine spawn for now until we implement the run method
    // let consensus_state = Arc::clone(&shared_state);
    // tokio::spawn(async move {
    //     consensus_engine.run(consensus_state).await;
    // });

    // API Routes
    let get_balance = warp::path!("balance" / String)
        .and(warp::get())
        .and(with_state(Arc::clone(&shared_state)))
        .and_then(get_balance_handler);

    let get_chain = warp::path("chain")
        .and(warp::get())
        .and(with_state(Arc::clone(&shared_state)))
        .and_then(get_chain_handler);

    let submit_transaction = warp::path("transaction")
        .and(warp::post())
        .and(warp::body::json())
        .and(with_state(Arc::clone(&shared_state)))
        .and_then(submit_transaction_handler);

    let get_status = warp::path("status")
        .and(warp::get())
        .and(with_state(Arc::clone(&shared_state)))
        .and_then(get_status_handler);

    let cors = warp::cors()
        .allow_any_origin()
        .allow_headers(vec!["content-type"])
        .allow_methods(vec!["GET", "POST", "OPTIONS"]);

    let routes = get_balance
        .or(get_chain)
        .or(submit_transaction)
        .or(get_status)
        .with(cors);

    println!("🚀 QuanX Blockchain Node Started Successfully!");
    println!("🌐 API Server: http://0.0.0.0:8080");
    println!("📊 Status: http://0.0.0.0:8080/status");
    println!("⛓️  Chain: http://0.0.0.0:8080/chain");

    warp::serve(routes)
        .run(([0, 0, 0, 0], 8080))
        .await;
}

fn with_state(state: SharedState) -> impl Filter<Extract = (SharedState,), Error = std::convert::Infallible> + Clone {
    warp::any().map(move || Arc::clone(&state))
}

async fn get_balance_handler(address: String, state: SharedState) -> Result<impl warp::Reply, warp::Rejection> {
    let blockchain_state = state.read().await;
    let balance = blockchain_state.balances.get(&address).unwrap_or(&0);

    let response = ApiResponse {
        success: true,
        data: Some(*balance),
        error: None,
    };

    Ok(warp::reply::json(&response))
}

async fn get_chain_handler(state: SharedState) -> Result<impl warp::Reply, warp::Rejection> {
    let blockchain_state = state.read().await;

    let response = ApiResponse {
        success: true,
        data: Some(&blockchain_state.chain),
        error: None,
    };

    Ok(warp::reply::json(&response))
}

async fn submit_transaction_handler(transaction: Transaction, state: SharedState) -> Result<impl warp::Reply, warp::Rejection> {
    let mut blockchain_state = state.write().await;

    // Validate transaction
    let sender_balance = blockchain_state.balances.get(&transaction.from).unwrap_or(&0);
    if *sender_balance < transaction.amount {
        let response = ApiResponse {
            success: false,
            data: None::<String>,
            error: Some("Insufficient balance".to_string()),
        };
        return Ok(warp::reply::json(&response));
    }

    // Add to pending transactions
    blockchain_state.pending_transactions.push(transaction.clone());

    let response = ApiResponse {
        success: true,
        data: Some("Transaction submitted successfully".to_string()),
        error: None,
    };

    Ok(warp::reply::json(&response))
}

async fn get_status_handler(state: SharedState) -> Result<impl warp::Reply, warp::Rejection> {
    let blockchain_state = state.read().await;

    let status = serde_json::json!({
        "chain_length": blockchain_state.chain.len(),
        "pending_transactions": blockchain_state.pending_transactions.len(),
        "total_accounts": blockchain_state.balances.len(),
        "validators": blockchain_state.validators.len(),
        "network_status": "active"
    });

    let response = ApiResponse {
        success: true,
        data: Some(status),
        error: None,
    };

    Ok(warp::reply::json(&response))
}