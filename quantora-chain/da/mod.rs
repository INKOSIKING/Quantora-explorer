//! Modular Data Availability: async, extensible adapters

use async_trait::async_trait;

#[async_trait]
pub trait DataAvailability: Send + Sync {
    async fn submit_data(&self, blob: &[u8]) -> Result<String, String>;
    async fn verify_data(&self, blob_ref: &str) -> bool;
}

pub struct CelestiaAdapter;
pub struct EigenAdapter;

#[async_trait]
impl DataAvailability for CelestiaAdapter {
    async fn submit_data(&self, blob: &[u8]) -> Result<String, String> {
        // Use reqwest/tonic to Celestia node
        Ok("celestia_blob_ref".to_owned())
    }
    async fn verify_data(&self, _blob_ref: &str) -> bool { true }
}

#[async_trait]
impl DataAvailability for EigenAdapter {
    async fn submit_data(&self, blob: &[u8]) -> Result<String, String> {
        Ok("eigen_blob_ref".to_owned())
    }
    async fn verify_data(&self, _blob_ref: &str) -> bool { true }
}