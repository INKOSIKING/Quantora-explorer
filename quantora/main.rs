use quantora::{Quantora, QuantoraConfig};
use quantora::runtime::vm::VmType;
use quantora::rollup::{RollupConfig, L2Mode};
use quantora::da::DAConfig;
use quantora::crypto::CryptoSuite;
use quantora::fees::FeeConfig;
use quantora::api::run_server;
use std::env;

#[tokio::main]
async fn main() {
    let eth_address = "0x91DE3e0f1EbCB20f0eda24ea946B880d252f97AB".to_string();
    let eth_rpc = env::var("ETH_RPC").unwrap_or_else(|_| "https://mainnet.infura.io/v3/YOUR_KEY".to_string());
    let eth_private_key = env::var("ETH_PRIVATE_KEY").expect("ETH_PRIVATE_KEY must be set");

    let fee_config = FeeConfig {
        min_fee: 1_000_000_000_000u128,
        min_send_fee: 500_000_000_000u128,
        min_receive_fee: 500_000_000_000u128,
        min_stake_fee: 1_000_000_000_000u128,
        min_unstake_fee: 1_000_000_000_000u128,
        eth_address,
        eth_rpc,
        eth_private_key,
    };

    let config = QuantoraConfig {
        vm_type: VmType::Evm,
        l2_mode: L2Mode::Validium,
        da_config: DAConfig::default(),
        rollup_config: RollupConfig::default(),
        crypto_suite: CryptoSuite::Legacy,
        fee_config,
    };

    let quantora = Quantora::new(config).await;
    println!("Quantora chain node starting on 0.0.0.0:8080...");
    run_server(quantora).await.expect("Failed to start Quantora node");
}