use reqwest::Client;
use serde::{Deserialize, Serialize};

pub struct QuantoraRestClient {
    base_url: String,
    client: Client,
}

impl QuantoraRestClient {
    pub fn new(base_url: &str) -> Self {
        Self { base_url: base_url.to_string(), client: Client::new() }
    }
    pub async fn get_assets(&self) -> Result<Vec<String>, reqwest::Error> {
        let resp = self.client.get(format!("{}/assets", self.base_url)).send().await?;
        let json: serde_json::Value = resp.json().await?;
        Ok(json["assets"].as_array().unwrap().iter().map(|a| a.as_str().unwrap().to_string()).collect())
    }
    // ...etc.
}