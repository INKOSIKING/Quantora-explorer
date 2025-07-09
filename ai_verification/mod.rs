pub mod verifier;
pub mod fraud_proof;
pub mod ai_oracle;
pub mod interface;

use verifier::AIVerifier;
use fraud_proof::FraudProofEngine;
use ai_oracle::AIOracleService;
use interface::{AIVerificationRequest, AIVerificationResult};

pub struct AIValidationLayer {
    pub verifier: AIVerifier,
    pub fraud_proof_engine: FraudProofEngine,
    pub oracle: AIOracleService,
}

impl AIValidationLayer {
    pub fn new() -> Self {
        Self {
            verifier: AIVerifier::default(),
            fraud_proof_engine: FraudProofEngine::default(),
            oracle: AIOracleService::default(),
        }
    }

    pub fn verify_contract(&self, req: &AIVerificationRequest) -> AIVerificationResult {
        // Try local fast static verifier, fallback to oracle/AI model
        match self.verifier.verify(req) {
            Some(result) => result,
            None => self.oracle.ask_verification(req),
        }
    }

    pub fn submit_fraud_proof(&self, proof: &[u8]) -> bool {
        self.fraud_proof_engine.submit(proof)
    }
}