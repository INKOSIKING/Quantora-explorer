//! Celestia DA adapter with error handling, health check, and observability

use async_trait::async_trait;
use reqwest::Client;
use tracing::{info, error};

pub struct CelestiaAdapter {
    pub endpoint: String,
    pub client: Client,
}

impl CelestiaAdapter {
    pub fn new(endpoint: &str) -> Self {
        Self { endpoint: endpoint.into(), client: Client::new() }
    }
    pub async fn health_check(&self) -> bool {
        match self.client.get(format!("{}/health", self.endpoint)).send().await {
            Ok(resp) => resp.status().is_success(),
            Err(_) => false,
        }
    }
}

#[async_trait]
impl super::DataAvailability for CelestiaAdapter {
    async fn submit_data(&self, blob: &[u8]) -> Result<String, String> {
        let url = format!("{}/submit", self.endpoint);
        let res = self.client.post(&url).body(blob.to_vec()).send().await;
        match res {
            Ok(resp) if resp.status().is_success() => {
                let txt = resp.text().await.unwrap_or_default();
                info!("Celestia DA submit ok: {}", txt);
                Ok(txt)
            },
            Ok(resp) => {
                error!("Celestia DA error: {}", resp.status());
                Err(format!("Celestia error: {}", resp.status()))
            },
            Err(err) => {
                error!("Celestia DA network error: {}", err);
                Err(format!("Celestia network error: {}", err))
            }
        }
    }
    async fn verify_data(&self, blob_ref: &str) -> bool {
        // Could check via REST or gRPC
        !blob_ref.is_empty()
    }
}