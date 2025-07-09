use sha2::{Digest, Sha256};

#[derive(Clone, Debug)]
pub struct Transaction {
    pub from: String,
    pub to: String,
    pub value: u64,
    pub nonce: u64,
    pub signature: String,
    pub data: Vec<u8>,
}

impl Transaction {
    pub fn hash(&self) -> String {
        let mut hasher = Sha256::new();
        hasher.update(self.from.as_bytes());
        hasher.update(self.to.as_bytes());
        hasher.update(&self.value.to_be_bytes());
        hasher.update(&self.nonce.to_be_bytes());
        hasher.update(self.signature.as_bytes());
        hasher.update(&self.data);
        hex::encode(hasher.finalize())
    }

    /// Creates a coinbase/genesis mint transaction
    pub fn genesis_mint(to: &str, value: u64) -> Self {
        Transaction {
            from: String::from("GENESIS"),
            to: to.to_string(),
            value,
            nonce: 0,
            signature: String::from("GENESIS"),
            data: vec![],
        }
    }
}