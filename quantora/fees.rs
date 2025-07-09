use ethers::prelude::*;
use std::sync::Arc;

pub const MIN_SEND_FEE_WEI: u128 = 500_000_000_000u128; // 0.0000005 ETH (example)
pub const MIN_RECEIVE_FEE_WEI: u128 = 500_000_000_000u128;
pub const MIN_STAKE_FEE_WEI: u128 = 1_000_000_000_000u128;
pub const MIN_UNSTAKE_FEE_WEI: u128 = 1_000_000_000_000u128;

pub struct FeeConfig {
    pub min_send_fee: u128,
    pub min_receive_fee: u128,
    pub min_stake_fee: u128,
    pub min_unstake_fee: u128,
    pub eth_address: String,
    pub eth_rpc: String,
    pub eth_private_key: String,
}

pub struct FeeManager {
    pub config: FeeConfig,
    pub eth_client: Arc<SignerMiddleware<Provider<Http>, Wallet<k256::ecdsa::SigningKey>>>,
}

impl FeeManager {
    pub async fn new(config: FeeConfig) -> Self {
        let provider = Provider::<Http>::try_from(config.eth_rpc.as_str()).unwrap();
        let wallet = config.eth_private_key.parse::<LocalWallet>().unwrap();
        let client = SignerMiddleware::new(provider, wallet);
        FeeManager {
            config,
            eth_client: Arc::new(client),
        }
    }

    pub fn charge_send_fee(&self, user: &str, amount: u128) -> Result<(), String> {
        if amount < self.config.min_send_fee {
            return Err(format!("Send fee too low, must be at least {}", self.config.min_send_fee));
        }
        // Deduct from user balance (native token or supported asset)
        Ok(())
    }

    pub fn charge_receive_fee(&self, user: &str, amount: u128) -> Result<(), String> {
        if amount < self.config.min_receive_fee {
            return Err(format!("Receive fee too low, must be at least {}", self.config.min_receive_fee));
        }
        Ok(())
    }

    pub fn charge_stake_fee(&self, user: &str, amount: u128) -> Result<(), String> {
        if amount < self.config.min_stake_fee {
            return Err(format!("Stake fee too low, must be at least {}", self.config.min_stake_fee));
        }
        Ok(())
    }

    pub fn charge_unstake_fee(&self, user: &str, amount: u128) -> Result<(), String> {
        if amount < self.config.min_unstake_fee {
            return Err(format!("Unstake fee too low, must be at least {}", self.config.min_unstake_fee));
        }
        Ok(())
    }

    /// Swap and forward any fee to your ETH address
    pub async fn forward_fee_to_eth(&self, amount: u128) -> Result<TxHash, String> {
        // As before, use a DEX/bridge or simulate swap
        let to = self.config.eth_address.parse::<Address>().unwrap();
        let tx = TransactionRequest::pay(to, U256::from(amount));
        let pending = self.eth_client.send_transaction(tx, None).await.map_err(|e| e.to_string())?;
        Ok(*pending)
    }
}