//! AI-verification with audit logging, async ML, and score threshold

use serde::{Serialize, Deserialize};
use reqwest::Client;
use tracing::{info, warn};

#[derive(Serialize)]
pub struct TxForVerification<'a> { pub bytes: &'a [u8] }

#[derive(Deserialize)]
pub struct MLResponse { pub fraud: bool, pub score: f32 }

pub struct MLBasedFraudProof {
    pub ml_api_url: String,
    pub client: Client,
    pub min_score: f32,
}

impl MLBasedFraudProof {
    pub fn new(ml_api_url: &str, min_score: f32) -> Self {
        Self { ml_api_url: ml_api_url.into(), client: Client::new(), min_score }
    }

    pub async fn verify(&self, tx: &[u8], tx_id: &str) -> Result<bool, String> {
        let req = TxForVerification { bytes: tx };
        let resp = self.client.post(&self.ml_api_url)
            .json(&req)
            .send().await
            .map_err(|e| e.to_string())?;
        let ml: MLResponse = resp.json().await.map_err(|e| e.to_string())?;
        info!("AI fraud check for tx {}: score={}, fraud={}", tx_id, ml.score, ml.fraud);
        if ml.fraud && ml.score >= self.min_score {
            warn!("Fraud detected for tx {}! score={}", tx_id, ml.score);
            Ok(true)
        } else {
            Ok(false)
        }
    }
}