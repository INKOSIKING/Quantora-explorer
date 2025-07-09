//! SPHINCS+ post-quantum signature scheme (NIST PQC finalist)
// Requires: pqcrypto-sphincsplus crate

use pqcrypto_sphincsplus::sphincssha256128srobust;

use super::{Signer, CryptoScheme};

pub struct SphincsSigner {
    pubkey: sphincssha256128srobust::PublicKey,
    seckey: sphincssha256128srobust::SecretKey,
}

impl Default for SphincsSigner {
    fn default() -> Self {
        let (pk, sk) = sphincssha256128srobust::keypair();
        Self { pubkey: pk, seckey: sk }
    }
}

impl Signer for SphincsSigner {
    fn sign(&self, msg: &[u8]) -> Vec<u8> {
        sphincssha256128srobust::sign(msg, &self.seckey)
    }
    fn verify(&self, msg: &[u8], sig: &[u8], pubkey: &[u8]) -> bool {
        let pk = match sphincssha256128srobust::PublicKey::from_bytes(pubkey) {
            Ok(pk) => pk,
            Err(_) => return false,
        };
        sphincssha256128srobust::verify(msg, sig, &pk).is_ok()
    }
    fn scheme(&self) -> CryptoScheme {
        CryptoScheme::Sphincs
    }
}