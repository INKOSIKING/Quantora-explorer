
use serde::{Deserialize, Serialize};
use bip39::{Mnemonic, Language};
use secp256k1::{SecretKey, PublicKey, Secp256k1};
use sha2::{Sha256, Digest};
use hex;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Wallet {
    pub address: String,
    pub seed_phrase: String,
    pub private_key: String,
    pub public_key: String,
}

impl Wallet {
    pub fn new(name: String) -> Self {
        // Generate a new mnemonic using updated bip39 API
        let mnemonic = Mnemonic::generate(12).unwrap();
        let seed_phrase = mnemonic.to_string();
        
        // Generate keys from mnemonic
        let seed = mnemonic.to_seed("");
        
        let secp = Secp256k1::new();
        let secret_key = SecretKey::from_slice(&seed[0..32]).unwrap();
        let public_key = PublicKey::from_secret_key(&secp, &secret_key);
        
        let address = Self::public_key_to_address(&public_key);
        
        Wallet {
            address,
            seed_phrase,
            private_key: hex::encode(secret_key.secret_bytes()),
            public_key: hex::encode(public_key.serialize()),
        }
    }
    
    fn public_key_to_address(public_key: &PublicKey) -> String {
        let mut hasher = Sha256::new();
        hasher.update(public_key.serialize());
        let hash = hasher.finalize();
        format!("QuanX{}", hex::encode(&hash[0..20]))
    }
}
