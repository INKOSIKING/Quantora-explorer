
use crate::wallet_api::{WalletAPI, CreateWalletResponse, TransferRequest, WalletInfo};
use crate::blockchain::Blockchain;
use serde_json::json;
use std::sync::Arc;
use tokio::sync::Mutex;
use warp::{Filter, Reply};

pub struct WebServer {
    wallet_api: WalletAPI,
}

impl WebServer {
    pub fn new(blockchain: Arc<Mutex<Blockchain>>) -> Self {
        Self {
            wallet_api: WalletAPI::new(blockchain),
        }
    }
    
    pub async fn start(&self) {
        let wallet_api = Arc::new(self.wallet_api.clone());
        
        // GET /api/wallet/create - Create new wallet
        let create_wallet = warp::path!("api" / "wallet" / "create")
            .and(warp::get())
            .and(with_wallet_api(wallet_api.clone()))
            .and_then(handle_create_wallet);
        
        // GET /api/wallet/{address} - Get wallet info
        let get_wallet = warp::path!("api" / "wallet" / String)
            .and(warp::get())
            .and(with_wallet_api(wallet_api.clone()))
            .and_then(handle_get_wallet);
        
        // POST /api/wallet/transfer - Transfer QuanX
        let transfer = warp::path!("api" / "wallet" / "transfer")
            .and(warp::post())
            .and(warp::body::json())
            .and(with_wallet_api(wallet_api.clone()))
            .and_then(handle_transfer);
        
        // GET /api/founder - Get founder wallet info
        let founder_wallet = warp::path!("api" / "founder")
            .and(warp::get())
            .and(with_wallet_api(wallet_api.clone()))
            .and_then(handle_founder_wallet);
        
        // GET /api/stats - Get blockchain stats
        let stats = warp::path!("api" / "stats")
            .and(warp::get())
            .and(with_wallet_api(wallet_api.clone()))
            .and_then(handle_stats);
        
        let routes = create_wallet
            .or(get_wallet)
            .or(transfer)
            .or(founder_wallet)
            .or(stats)
            .with(warp::cors().allow_any_origin());
        
        println!("🌐 QuanX Web API starting on http://0.0.0.0:3000");
        warp::serve(routes).run(([0, 0, 0, 0], 3000)).await;
    }
}

fn with_wallet_api(
    wallet_api: Arc<WalletAPI>
) -> impl Filter<Extract = (Arc<WalletAPI>,), Error = std::convert::Infallible> + Clone {
    warp::any().map(move || wallet_api.clone())
}

async fn handle_create_wallet(
    wallet_api: Arc<WalletAPI>
) -> Result<impl Reply, warp::Rejection> {
    let wallet = wallet_api.create_wallet().await;
    Ok(warp::reply::json(&wallet))
}

async fn handle_get_wallet(
    address: String,
    wallet_api: Arc<WalletAPI>
) -> Result<impl Reply, warp::Rejection> {
    let wallet_info = wallet_api.get_wallet_info(&address).await;
    Ok(warp::reply::json(&wallet_info))
}

async fn handle_transfer(
    request: TransferRequest,
    wallet_api: Arc<WalletAPI>
) -> Result<impl Reply, warp::Rejection> {
    match wallet_api.transfer_quanx(request).await {
        Ok(result) => Ok(warp::reply::json(&json!({"success": true, "message": result}))),
        Err(error) => Ok(warp::reply::json(&json!({"success": false, "error": error}))),
    }
}

async fn handle_founder_wallet(
    wallet_api: Arc<WalletAPI>
) -> Result<impl Reply, warp::Rejection> {
    let founder_info = wallet_api.get_founder_wallet().await;
    Ok(warp::reply::json(&founder_info))
}

async fn handle_stats(
    wallet_api: Arc<WalletAPI>
) -> Result<impl Reply, warp::Rejection> {
    let blockchain = wallet_api.blockchain.lock().await;
    let stats = blockchain.get_blockchain_stats();
    Ok(warp::reply::json(&stats))
}
