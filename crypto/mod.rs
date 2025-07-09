pub mod quantum_safe;
pub mod legacy;
pub mod toggle;
pub mod interface;

use quantum_safe::{QuantumSafeCrypto, PQAlgorithm};
use legacy::LegacyCrypto;
use toggle::CryptoToggle;
use interface::{CryptoSuite, CryptoError};

pub struct CryptoLayer {
    pub legacy: LegacyCrypto,
    pub quantum: QuantumSafeCrypto,
    pub toggle: CryptoToggle,
}

impl CryptoLayer {
    pub fn new() -> Self {
        Self {
            legacy: LegacyCrypto::default(),
            quantum: QuantumSafeCrypto::default(),
            toggle: CryptoToggle::default(),
        }
    }

    pub fn sign(&self, suite: CryptoSuite, msg: &[u8], privkey: &[u8]) -> Result<Vec<u8>, CryptoError> {
        match suite {
            CryptoSuite::Legacy => self.legacy.sign(msg, privkey),
            CryptoSuite::QuantumSafe(algo) => self.quantum.sign(algo, msg, privkey),
        }
    }

    pub fn verify(&self, suite: CryptoSuite, msg: &[u8], sig: &[u8], pubkey: &[u8]) -> Result<bool, CryptoError> {
        match suite {
            CryptoSuite::Legacy => self.legacy.verify(msg, sig, pubkey),
            CryptoSuite::QuantumSafe(algo) => self.quantum.verify(algo, msg, sig, pubkey),
        }
    }

    pub fn toggle_suite(&mut self, suite: CryptoSuite) {
        self.toggle.set_suite(suite);
    }

    pub fn current_suite(&self) -> CryptoSuite {
        self.toggle.get_suite()
    }
}