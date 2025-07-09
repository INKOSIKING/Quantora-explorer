use rand::RngCore;
use sha2::{Sha256, Digest};

pub fn generate_address() -> String {
    let mut rng = rand::thread_rng();
    let mut buf = [0u8; 32];
    rng.fill_bytes(&mut buf);
    let hash = Sha256::digest(&buf);
    hex::encode(&hash[0..20])
}