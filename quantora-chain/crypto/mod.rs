//! Quantum-safe crypto module: classical and post-quantum signature support

pub mod ed25519;
pub mod secp256k1;
pub mod dilithium;
pub mod falcon;
pub mod sphincs;

// Enum to represent available signature schemes
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum CryptoScheme {
    Ed25519,
    Secp256k1,
    Dilithium,
    Falcon,
    Sphincs,
}

pub trait Signer {
    fn sign(&self, msg: &[u8]) -> Vec<u8>;
    fn verify(&self, msg: &[u8], sig: &[u8], pubkey: &[u8]) -> bool;
    fn scheme(&self) -> CryptoScheme;
}

// Factory for toggling schemes globally (can be set in config)
pub struct CryptoProvider {
    scheme: CryptoScheme,
}

impl CryptoProvider {
    pub fn new(scheme: CryptoScheme) -> Self {
        Self { scheme }
    }
    pub fn signer(&self) -> Box<dyn Signer + Send + Sync> {
        match self.scheme {
            CryptoScheme::Ed25519 => Box::new(ed25519::Ed25519Signer::default()),
            CryptoScheme::Secp256k1 => Box::new(secp256k1::Secp256k1Signer::default()),
            CryptoScheme::Dilithium => Box::new(dilithium::DilithiumSigner::default()),
            CryptoScheme::Falcon => Box::new(falcon::FalconSigner::default()),
            CryptoScheme::Sphincs => Box::new(sphincs::SphincsSigner::default()),
        }
    }
    pub fn get_scheme(&self) -> CryptoScheme {
        self.scheme
    }
}