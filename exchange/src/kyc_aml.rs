use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use reqwest::Client;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum KycStatus {
    NotStarted,
    Pending,
    Approved,
    Rejected,
    ReviewRequired,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct KycRecord {
    pub user_id: Uuid,
    pub status: KycStatus,
    pub submitted_at: Option<DateTime<Utc>>,
    pub approved_at: Option<DateTime<Utc>>,
    pub rejected_at: Option<DateTime<Utc>>,
    pub provider_session_id: Option<String>,
    pub rejection_reason: Option<String>,
}

pub struct KycProvider {
    pub api_base: String,
    pub api_key: String,
    pub client: Client,
}

impl KycProvider {
    pub fn new(api_base: &str, api_key: &str) -> Self {
        Self {
            api_base: api_base.to_string(),
            api_key: api_key.to_string(),
            client: Client::new(),
        }
    }

    pub async fn start_kyc(&self, user_id: Uuid) -> Result<KycRecord, String> {
        // Example: Start KYC session with provider
        let req_body = serde_json::json!({
            "external_user_id": user_id.to_string(),
        });
        let res = self.client
            .post(format!("{}/api/v1/kyc/start", self.api_base))
            .header("Authorization", format!("Bearer {}", self.api_key))
            .json(&req_body)
            .send()
            .await
            .map_err(|e| format!("Failed to start KYC: {}", e))?;

        let resp_json: serde_json::Value = res.json().await.map_err(|e| e.to_string())?;
        let session_id = resp_json.get("session_id").and_then(|v| v.as_str()).unwrap_or("").to_string();

        Ok(KycRecord {
            user_id,
            status: KycStatus::Pending,
            submitted_at: Some(Utc::now()),
            approved_at: None,
            rejected_at: None,
            provider_session_id: Some(session_id),
            rejection_reason: None,
        })
    }

    pub async fn get_kyc_status(&self, record: &KycRecord) -> Result<KycStatus, String> {
        if record.provider_session_id.is_none() {
            return Ok(KycStatus::NotStarted);
        }
        let url = format!("{}/api/v1/kyc/status/{}", self.api_base, record.provider_session_id.as_ref().unwrap());
        let res = self.client
            .get(url)
            .header("Authorization", format!("Bearer {}", self.api_key))
            .send()
            .await
            .map_err(|e| format!("Failed to fetch status: {}", e))?;

        let resp_json: serde_json::Value = res.json().await.map_err(|e| e.to_string())?;
        let status_str = resp_json.get("status").and_then(|v| v.as_str()).unwrap_or("pending");

        let status = match status_str {
            "approved" => KycStatus::Approved,
            "rejected" => KycStatus::Rejected,
            "pending" => KycStatus::Pending,
            "review" => KycStatus::ReviewRequired,
            _ => KycStatus::Pending,
        };
        Ok(status)
    }
}