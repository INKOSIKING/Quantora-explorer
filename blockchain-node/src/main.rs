
use tokio;
use log::{info, error};
use std::sync::Arc;
use tokio::sync::Mutex;

mod blockchain;
mod network;
mod consensus;

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
    
    info!("Blockchain node started successfully");
    info!("Network listening on 0.0.0.0:8080");
    
    // Wait for both tasks
    tokio::try_join!(network_handle, consensus_handle)?;
    
    Ok(())
}
