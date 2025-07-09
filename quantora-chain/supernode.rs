//! Quantora SuperNode: Full integration of blockchain, exchange, CoinGecko registry, multi-asset wallet, and DeFi logic.

mod runtime;
mod zkrollup;
mod da;
mod ai_verification;
mod asset_tools;
mod governance;
mod staking;

// Exchange modules
pub mod exchange {
    pub mod asset_registry;
    pub mod swap_engine;
    pub mod wallet;
    pub mod lend_stake;
    pub mod quantora_wallet;
}

use runtime::{dispatcher::VmDispatcher, VmType};
use zkrollup::{ZkRollup, ZkBatch};
use da::celestia::CelestiaAdapter;
use ai_verification::fraud_proofs::MLBasedFraudProof;
use asset_tools::factory::{DefaultAssetFactory, TokenParams, NFTParams, DAOParams};
use governance::{Governance, Proposal, VotingType};
use staking::{ValidatorSet, Validator, Slashing};

use exchange::{
    asset_registry::AssetRegistry,
    swap_engine::SwapEngine,
    wallet::UserWallet,
    lend_stake::StakingEngine,
    quantora_wallet::QuantoraWalletManager,
};

use sqlx::PgPool;
use reqwest::Client;
use std::sync::Arc;
use tracing::{info, error};

pub struct QuantoraSuperNode {
    // Quantora blockchain core
    pub vms: Arc<VmDispatcher>,
    pub zkrollup: Arc<ZkRollup<CelestiaAdapter>>,
    pub da: Arc<CelestiaAdapter>,
    pub ml_fraud: Arc<MLBasedFraudProof>,
    pub asset_factory: Arc<DefaultAssetFactory>,
    pub governance: Arc<tokio::sync::Mutex<Governance>>,
    pub validators: Arc<tokio::sync::Mutex<ValidatorSet>>,
    pub slashing: Arc<Slashing>,

    // Exchange & registry
    pub asset_registry: Arc<AssetRegistry>,
    pub swap_engine: Arc<tokio::sync::Mutex<SwapEngine<'static>>>,
    pub staking_engine: Arc<tokio::sync::Mutex<StakingEngine>>,
    pub quantora_wallet_manager: Arc<QuantoraWalletManager>,
    pub user_wallets: Arc<tokio::sync::Mutex<std::collections::HashMap<String, UserWallet>>>, // user_id -> wallet
}

impl QuantoraSuperNode {
    pub async fn new(pg_url: &str, da_endpoint: &str, ml_api_url: &str, min_validator_stake: u128) -> Self {
        // Set up DB, HTTP, and all managers
        let pool = PgPool::connect(pg_url).await.unwrap();
        let client = Client::new();
        let quantora_wallet_manager = Arc::new(QuantoraWalletManager::default());
        let asset_registry = Arc::new(AssetRegistry {
            pool: pool.clone(),
            client: client.clone(),
            quantora_wallet_manager: quantora_wallet_manager.clone(),
        });

        // Sync assets from CoinGecko and create Quantora wallets for each
        asset_registry.sync_and_create_wallets().await.expect("Asset sync failed");

        // Prepare swap engine (with dynamic price/routing updates)
        let swap_engine = Arc::new(tokio::sync::Mutex::new(SwapEngine {
            registry: unsafe { &*(Arc::as_ptr(&asset_registry) as *const AssetRegistry) }, // Lifetime fudge for demo
            pairs: Default::default(),
        }));

        let staking_engine = Arc::new(tokio::sync::Mutex::new(StakingEngine::default()));
        let user_wallets = Arc::new(tokio::sync::Mutex::new(std::collections::HashMap::new()));

        // Quantora core
        let da = Arc::new(CelestiaAdapter::new(da_endpoint));
        let zkrollup = Arc::new(ZkRollup::new((*da).clone()));
        let vms = Arc::new(VmDispatcher::new());
        let ml_fraud = Arc::new(MLBasedFraudProof::new(ml_api_url, 0.85));
        let asset_factory = Arc::new(DefaultAssetFactory { runtime: runtime::Runtime::new() });
        let governance = Arc::new(tokio::sync::Mutex::new(Governance::new()));
        let validators = Arc::new(tokio::sync::Mutex::new(ValidatorSet { validators: Default::default(), min_stake: min_validator_stake }));
        let slashing = Arc::new(Slashing);

        QuantoraSuperNode {
            vms, zkrollup, da, ml_fraud, asset_factory, governance, validators, slashing,
            asset_registry,
            swap_engine,
            staking_engine,
            quantora_wallet_manager,
            user_wallets,
        }
    }

    /// User-level: trade/swap between any supported assets (with on-chain wallet logic).
    pub async fn swap_assets(
        &self,
        user: &str,
        from: &str,
        to: &str,
        amount: rust_decimal::Decimal,
    ) -> Result<rust_decimal::Decimal, String> {
        let mut wallets = self.user_wallets.lock().await;
        let user_wallet = wallets.entry(user.to_string())
            .or_insert_with(|| UserWallet {
                quantora_manager: (*self.quantora_wallet_manager).clone(),
                ..Default::default()
            });
        if !user_wallet.withdraw(from, amount) {
            return Err("Insufficient funds".into());
        }
        let received = self.swap_engine.lock().await.swap(from, to, amount).await.map_err(|e| format!("{:?}", e))?;
        user_wallet.deposit(to, received);
        info!("User {} swapped {} {} for {} {}", user, amount, from, received, to);
        Ok(received)
    }

    /// Stake any coin (on Quantora, off-chain or with DeFi logic)
    pub async fn stake_asset(&self, user: &str, symbol: &str, amount: rust_decimal::Decimal) -> Result<(), String> {
        let mut wallets = self.user_wallets.lock().await;
        let user_wallet = wallets.entry(user.to_string())
            .or_insert_with(|| UserWallet {
                quantora_manager: (*self.quantora_wallet_manager).clone(),
                ..Default::default()
            });
        if !user_wallet.withdraw(symbol, amount) {
            return Err("Insufficient funds to stake".into());
        }
        self.staking_engine.lock().await.stake(user, symbol, amount)?;
        info!("User {} staked {} {}", user, amount, symbol);
        Ok(())
    }

    /// Lend any coin (for credit/DeFi logic)
    pub async fn lend_asset(&self, user: &str, symbol: &str, amount: rust_decimal::Decimal) -> Result<(), String> {
        // For brevity, similar to stake_asset; can implement lending market logic here
        Ok(())
    }

    /// User wallet balance for any asset
    pub async fn user_balance(&self, user: &str, symbol: &str) -> rust_decimal::Decimal {
        self.user_wallets.lock().await
            .get(user)
            .map(|w| w.balance(symbol))
            .unwrap_or(rust_decimal::Decimal::ZERO)
    }

    /// Get Quantora on-chain wallet for any asset
    pub async fn user_asset_wallet_addr(&self, user: &str, symbol: &str) -> Option<String> {
        self.user_wallets.lock().await
            .get(user)
            .and_then(|w| futures::executor::block_on(w.get_chain_wallet(symbol)))
    }

    // The rest of Quantora’s blockchain logic (core, governance, validator mgmt, etc.) is as before.
}