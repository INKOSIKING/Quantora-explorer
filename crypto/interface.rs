#[derive(Debug, Clone, Copy)]
pub enum PQAlgorithm {
    Falcon,
    Dilithium,
    SphincsPlus,
}

#[derive(Debug, Clone, Copy)]
pub enum CryptoSuite {
    Legacy,
    QuantumSafe(PQAlgorithm),
}

#[derive(Debug, Clone)]
pub enum CryptoError {
    Unsupported,
    InvalidKey,
    InvalidSignature,
    Internal(String),
}