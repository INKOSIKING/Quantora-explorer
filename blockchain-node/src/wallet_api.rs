
use crate::blockchain::{Blockchain, Transaction, TransactionType, Wallet};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::sync::Mutex;
use chrono::Utc;

#[derive(Debug, Serialize, Deserialize)]
pub struct CreateWalletResponse {
    pub address: String,
    pub seed_phrase: String,
    pub public_key: String,
    pub balance: u64,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct TransferRequest {
    pub from_seed: String,
    pub to_address: String,
    pub amount: u64,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct WalletInfo {
    pub address: String,
    pub balance: u64,
    pub formatted_balance: String,
}

pub struct WalletAPI {
    pub blockchain: Arc<Mutex<Blockchain>>,
}

impl WalletAPI {
    pub fn new(blockchain: Arc<Mutex<Blockchain>>) -> Self {
        Self { blockchain }
    }
    
    pub async fn create_wallet(&self) -> CreateWalletResponse {
        let wallet = Blockchain::create_wallet();
        let blockchain = self.blockchain.lock().await;
        let balance = blockchain.get_balance(&wallet.address);
        
        CreateWalletResponse {
            address: wallet.address,
            seed_phrase: wallet.seed_phrase,
            public_key: wallet.public_key,
            balance,
        }
    }
    
    pub async fn get_wallet_info(&self, address: &str) -> WalletInfo {
        let blockchain = self.blockchain.lock().await;
        let balance = blockchain.get_balance(address);
        let formatted_balance = self.format_amount(balance);
        
        WalletInfo {
            address: address.to_string(),
            balance,
            formatted_balance,
        }
    }
    
    pub async fn transfer_quanx(&self, request: TransferRequest) -> Result<String, String> {
        // In a real implementation, you'd verify the seed phrase and create a proper signature
        // For this demo, we'll create a basic transaction
        
        let transaction = Transaction {
            from: "placeholder".to_string(), // Would derive from seed phrase
            to: request.to_address,
            amount: request.amount,
            timestamp: Utc::now(),
            signature: "placeholder_signature".to_string(),
            tx_type: TransactionType::Transfer,
        };
        
        let mut blockchain = self.blockchain.lock().await;
        blockchain.add_transaction(transaction)?;
        
        Ok("Transaction added to pending pool".to_string())
    }
    
    pub async fn get_founder_wallet(&self) -> CreateWalletResponse {
        let blockchain = self.blockchain.lock().await;
        let founder_info = blockchain.get_founder_info();
        let balance = blockchain.get_balance(&founder_info.address);
        
        CreateWalletResponse {
            address: founder_info.address.clone(),
            seed_phrase: founder_info.seed_phrase.clone(),
            public_key: founder_info.public_key.clone(),
            balance,
        }
    }
    
    fn format_amount(&self, amount: u64) -> String {
        if amount >= 1_000_000_000_000 {
            format!("{:.1}T QuanX", amount as f64 / 1_000_000_000_000.0)
        } else if amount >= 1_000_000_000 {
            format!("{:.1}B QuanX", amount as f64 / 1_000_000_000.0)
        } else if amount >= 1_000_000 {
            format!("{:.1}M QuanX", amount as f64 / 1_000_000.0)
        } else {
            format!("{} QuanX", amount)
        }
    }
}
