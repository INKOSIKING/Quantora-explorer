
use tokio;
use log::{info, error};
use std::sync::Arc;
use tokio::sync::Mutex;

mod blockchain;
mod network;
mod consensus;
mod wallet_api;
mod web_server;

use blockchain::Blockchain;
use network::NetworkManager;
use consensus::ConsensusEngine;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    env_logger::init();
    
    info!("Starting Quantora blockchain node...");
    
    // Initialize blockchain
    let blockchain = Arc::new(Mutex::new(Blockchain::new()));
    
    // Initialize network manager
    let network = Arc::new(NetworkManager::new());
    
    // Initialize consensus engine
    let consensus = Arc::new(ConsensusEngine::new());
    
    // Start network listener
    let network_handle = {
        let network = network.clone();
        tokio::spawn(async move {
            if let Err(e) = network.start_listener("0.0.0.0:8080").await {
                error!("Network error: {}", e);
            }
        })
    };
    
    // Start consensus engine
    let consensus_handle = {
        let consensus = consensus.clone();
        let blockchain = blockchain.clone();
        tokio::spawn(async move {
            consensus.start(blockchain).await;
        })
    };
    
    // Start web server
    let web_handle = {
        let blockchain = blockchain.clone();
        tokio::spawn(async move {
            let web_server = web_server::WebServer::new(blockchain);
            web_server.start().await;
        })
    };
    
    info!("🚀 QuanX Blockchain Node Started Successfully!");
    info!("🌐 Network listening on 0.0.0.0:8080");
    
    // Display founder wallet information
    {
        let blockchain_lock = blockchain.lock().await;
        let founder_info = blockchain_lock.get_founder_info();
        let stats = blockchain_lock.get_blockchain_stats();
        
        info!("💰 QuanX Token Information:");
        info!("   Total Supply: {} QuanX", stats.get("total_supply").unwrap());
        info!("   🔥 Burned (Untouchable): {} QuanX", stats.get("burned_supply").unwrap());
        info!("   ⛏️  Mining Pool: {} QuanX", stats.get("mining_pool").unwrap());
        info!("   👤 Founder Allocation: {} QuanX", stats.get("founder_allocation").unwrap());
        info!("");
        info!("🔑 FOUNDER WALLET CREDENTIALS:");
        info!("   Address: {}", founder_info.address);
        info!("   Seed Phrase: {}", founder_info.seed_phrase);
        info!("   Balance: {} QuanX", blockchain_lock.get_balance(&founder_info.address));
        info!("");
        info!("⚠️  IMPORTANT: Save your seed phrase securely!");
        info!("   This wallet contains 6 trillion QuanX tokens.");
    }
    
    // Wait for all services
    tokio::try_join!(network_handle, consensus_handle, web_handle)?;
    
    Ok(())
}
use log::{info, error};
use std::env;
use tokio::time::{sleep, Duration};

mod blockchain;
mod network;
mod consensus;
mod storage;
mod health;

use blockchain::Blockchain;
use network::NetworkManager;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    env_logger::init();
    
    info!("🚀 Starting Quantora Blockchain Node...");
    
    // Initialize blockchain
    let mut blockchain = Blockchain::new();
    
    // Create genesis block if needed
    if blockchain.get_chain().is_empty() {
        info!("📦 Creating genesis block...");
        blockchain.create_genesis_block()?;
        info!("✅ Genesis block created");
    }
    
    // Start network manager
    let network = NetworkManager::new("0.0.0.0:8545".to_string());
    
    info!("🌐 Starting network on 0.0.0.0:8545");
    tokio::spawn(async move {
        if let Err(e) = network.start().await {
            error!("Network error: {}", e);
        }
    });
    
    // Start health check endpoint
    let health_server = health::start_health_server();
    tokio::spawn(health_server);
    
    info!("✅ Quantora Blockchain Node is running!");
    info!("📊 Health check: http://0.0.0.0:3030/health");
    info!("🔗 RPC endpoint: http://0.0.0.0:8545");
    
    // Keep the main thread alive
    loop {
        sleep(Duration::from_secs(30)).await;
        info!("💓 Node heartbeat - {} blocks", blockchain.get_chain().len());
    }
}
