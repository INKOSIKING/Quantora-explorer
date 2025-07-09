//! Dilithium post-quantum signature scheme (NIST PQC winner)
// Requires: pqcrypto-dilithium crate

use pqcrypto_dilithium::dilithium2;

use super::{Signer, CryptoScheme};

pub struct DilithiumSigner {
    pubkey: dilithium2::PublicKey,
    seckey: dilithium2::SecretKey,
}

impl Default for DilithiumSigner {
    fn default() -> Self {
        let (pk, sk) = dilithium2::keypair();
        Self { pubkey: pk, seckey: sk }
    }
}

impl Signer for DilithiumSigner {
    fn sign(&self, msg: &[u8]) -> Vec<u8> {
        dilithium2::sign(msg, &self.seckey)
    }
    fn verify(&self, msg: &[u8], sig: &[u8], pubkey: &[u8]) -> bool {
        let pk = match dilithium2::PublicKey::from_bytes(pubkey) {
            Ok(pk) => pk,
            Err(_) => return false,
        };
        dilithium2::verify(msg, sig, &pk).is_ok()
    }
    fn scheme(&self) -> CryptoScheme {
        CryptoScheme::Dilithium
    }
}