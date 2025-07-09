//! Ed25519 signature scheme (classical, robust, production-ready)

use ed25519_dalek::{Keypair, PublicKey, Signature, Signer as DalekSigner, Verifier};
use rand::rngs::OsRng;

use super::{Signer, CryptoScheme};

pub struct Ed25519Signer {
    keypair: Keypair,
}

impl Default for Ed25519Signer {
    fn default() -> Self {
        let mut csprng = OsRng {};
        let keypair: Keypair = Keypair::generate(&mut csprng);
        Self { keypair }
    }
}

impl Signer for Ed25519Signer {
    fn sign(&self, msg: &[u8]) -> Vec<u8> {
        self.keypair.sign(msg).to_bytes().to_vec()
    }
    fn verify(&self, msg: &[u8], sig: &[u8], pubkey: &[u8]) -> bool {
        let pk = match PublicKey::from_bytes(pubkey) {
            Ok(pk) => pk,
            Err(_) => return false,
        };
        let signature = match Signature::from_bytes(sig) {
            Ok(s) => s,
            Err(_) => return false,
        };
        pk.verify(msg, &signature).is_ok()
    }
    fn scheme(&self) -> CryptoScheme {
        CryptoScheme::Ed25519
    }
}