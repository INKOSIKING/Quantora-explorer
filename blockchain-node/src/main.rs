mod blockchain;
mod consensus;
mod mempool;
mod api;
mod network;

use blockchain::Blockchain;
use consensus::hybrid::HybridConsensusEngine;
use mempool::Mempool;
use api::run_api_server;
use network::NetworkNode;

use std::sync::{Arc, Mutex};
use tokio::time::{sleep, Duration};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize logging
    env_logger::init();

    println!("🚀 Starting QuanX Blockchain Node...");

    // Initialize blockchain
    let blockchain = Arc::new(Mutex::new(Blockchain::new()));

    // Initialize consensus engine
    let mut consensus_engine = HybridConsensusEngine::new();

    // Initialize mempool
    let mempool = Arc::new(Mutex::new(Mempool::new(10000)));

    // Initialize network node
    let network_node = NetworkNode::new(9000);

    // Display founder information
    {
        let chain = blockchain.lock().unwrap();
        let founder = chain.get_founder_info();
        println!("👑 Founder Wallet: {}", founder.address);
        println!("🌱 Seed Phrase: {}", founder.seed_phrase);
        println!("💰 Initial Balance: {} QuanX", chain.get_balance(&founder.address));
    }

    // Start API server
    let api_blockchain = blockchain.clone();
    tokio::spawn(async move {
        run_api_server(api_blockchain).await;
    });

    // Start network node
    tokio::spawn(async move {
        if let Err(e) = network_node.start().await {
            eprintln!("❌ Network error: {}", e);
        }
    });

    // Mining loop
    let mining_blockchain = blockchain.clone();
    tokio::spawn(async move {
        loop {
            sleep(Duration::from_secs(10)).await;

            let mut chain = mining_blockchain.lock().unwrap();
            let founder_address = chain.get_founder_info().address.clone();
            let block = chain.mine_block(founder_address);

            println!("⛏️  Mined block #{}", block.header.index);
        }
    });

    // Display performance metrics
    println!("{}", consensus_engine.performance_report());

    // Keep the main thread alive
    loop {
        sleep(Duration::from_secs(60)).await;

        let chain = blockchain.lock().unwrap();
        let stats = chain.get_blockchain_stats();
        println!("📊 Blockchain Stats:");
        for (key, value) in stats {
            println!("   {}: {}", key, value);
        }
    }
}