//! Quantora supernode async entrypoint: integrates blockchain, exchange, CoinGecko, wallets, DeFi

mod supernode;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    let node = supernode::QuantoraSuperNode::new(
        "postgres://user:password@localhost/quantora",
        "http://localhost:26658", // Celestia endpoint
        "http://localhost:5000/ml/fraud", // ML fraud proof API
        1_000_000 // Min validator stake
    ).await;

    // Example: User swaps 1 BTC to QTA (assuming user has BTC)
    let _ = node.swap_assets("alice", "btc", "qta", rust_decimal::Decimal::ONE).await;

    // Example: User stakes QTA
    let _ = node.stake_asset("alice", "qta", rust_decimal::Decimal::new(100, 0)).await;

    // Example: Get Alice's QTA wallet address on Quantora
    if let Some(addr) = node.user_asset_wallet_addr("alice", "qta").await {
        println!("Alice's QTA Quantora wallet: {}", addr);
    }
}