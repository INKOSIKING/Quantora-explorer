use bip39::{Mnemonic, Language};
use secp256k1::{PublicKey, SecretKey};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::str::FromStr;
use rand::rngs::OsRng;
use rand::RngCore;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Wallet {
    pub private_key: String,
    pub public_key: String,
    pub address: String,
    pub mnemonic: String,
}

impl Wallet {
    pub fn new() -> Self {
        Self::new_with_name("default".to_string())
    }

    pub fn new_with_name(name: String) -> Self {
        let mut entropy = [0u8; 16];
        OsRng.fill_bytes(&mut entropy);
        let mnemonic = Mnemonic::from_entropy_in(Language::English, &entropy).unwrap();
        let seed_phrase = mnemonic.to_string();

        // Generate keys from mnemonic
        let seed = mnemonic.to_seed("");

        let secp = Secp256k1::new();
        let secret_key = SecretKey::from_slice(&seed[0..32]).unwrap();
        let public_key = PublicKey::from_secret_key(&secp, &secret_key);

        let address = Self::public_key_to_address(&public_key);

        Wallet {
            address,
            mnemonic: seed_phrase,
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