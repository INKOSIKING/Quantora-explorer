use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use reqwest::Client;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum FiatStatus {
    Pending,
    Completed,
    Failed,
    Cancelled,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FiatDepositRequest {
    pub id: Uuid,
    pub user_id: Uuid,
    pub amount: f64,
    pub currency: String,
    pub provider: String,
    pub status: FiatStatus,
    pub provider_ref: Option<String>,
    pub created_at: DateTime<Utc>,
    pub completed_at: Option<DateTime<Utc>>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FiatWithdrawalRequest {
    pub id: Uuid,
    pub user_id: Uuid,
    pub amount: f64,
    pub currency: String,
    pub provider: String,
    pub bank_account: String,
    pub status: FiatStatus,
    pub provider_ref: Option<String>,
    pub created_at: DateTime<Utc>,
    pub completed_at: Option<DateTime<Utc>>,
}

pub struct FiatProvider {
    pub api_base: String,
    pub api_key: String,
    pub client: Client,
}

impl FiatProvider {
    pub fn new(api_base: &str, api_key: &str) -> Self {
        Self {
            api_base: api_base.to_string(),
            api_key: api_key.to_string(),
            client: Client::new(),
        }
    }

    pub async fn initiate_deposit(&self, user_id: Uuid, amount: f64, currency: &str) -> Result<FiatDepositRequest, String> {
        // Example: Stripe or Circle API call
        let req_body = serde_json::json!({
            "user_id": user_id.to_string(),
            "amount": amount,
            "currency": currency,
        });
        let res = self.client
            .post(format!("{}/v1/fiat/deposit", self.api_base))
            .header("Authorization", format!("Bearer {}", self.api_key))
            .json(&req_body)
            .send()
            .await
            .map_err(|e| format!("Failed to initiate deposit: {}", e))?;
        let resp_json: serde_json::Value = res.json().await.map_err(|e| e.to_string())?;
        let ref_id = resp_json.get("reference").and_then(|v| v.as_str()).unwrap_or("").to_string();

        Ok(FiatDepositRequest {
            id: Uuid::new_v4(),
            user_id,
            amount,
            currency: currency.to_string(),
            provider: self.api_base.clone(),
            status: FiatStatus::Pending,
            provider_ref: Some(ref_id),
            created_at: Utc::now(),
            completed_at: None,
        })
    }

    pub async fn initiate_withdrawal(&self, user_id: Uuid, amount: f64, currency: &str, bank_account: &str) -> Result<FiatWithdrawalRequest, String> {
        // Example: Stripe/Circle payout
        let req_body = serde_json::json!({
            "user_id": user_id.to_string(),
            "amount": amount,
            "currency": currency,
            "bank_account": bank_account,
        });
        let res = self.client
            .post(format!("{}/v1/fiat/withdraw", self.api_base))
            .header("Authorization", format!("Bearer {}", self.api_key))
            .json(&req_body)
            .send()
            .await
            .map_err(|e| format!("Failed to initiate withdrawal: {}", e))?;
        let resp_json: serde_json::Value = res.json().await.map_err(|e| e.to_string())?;
        let ref_id = resp_json.get("reference").and_then(|v| v.as_str()).unwrap_or("").to_string();

        Ok(FiatWithdrawalRequest {
            id: Uuid::new_v4(),
            user_id,
            amount,
            currency: currency.to_string(),
            provider: self.api_base.clone(),
            bank_account: bank_account.to_string(),
            status: FiatStatus::Pending,
            provider_ref: Some(ref_id),
            created_at: Utc::now(),
            completed_at: None,
        })
    }

    pub async fn check_deposit_status(&self, deposit: &FiatDepositRequest) -> Result<FiatStatus, String> {
        if let Some(ref_id) = &deposit.provider_ref {
            let url = format!("{}/v1/fiat/deposit/status/{}", self.api_base, ref_id);
            let res = self.client
                .get(url)
                .header("Authorization", format!("Bearer {}", self.api_key))
                .send()
                .await
                .map_err(|e| format!("Failed to check status: {}", e))?;
            let resp_json: serde_json::Value = res.json().await.map_err(|e| e.to_string())?;
            let status_str = resp_json.get("status").and_then(|v| v.as_str()).unwrap_or("pending");
            return Ok(match status_str {
                "completed" => FiatStatus::Completed,
                "failed" => FiatStatus::Failed,
                "cancelled" => FiatStatus::Cancelled,
                _ => FiatStatus::Pending,
            });
        }
        Ok(FiatStatus::Pending)
    }

    pub async fn check_withdrawal_status(&self, withdrawal: &FiatWithdrawalRequest) -> Result<FiatStatus, String> {
        if let Some(ref_id) = &withdrawal.provider_ref {
            let url = format!("{}/v1/fiat/withdraw/status/{}", self.api_base, ref_id);
            let res = self.client
                .get(url)
                .header("Authorization", format!("Bearer {}", self.api_key))
                .send()
                .await
                .map_err(|e| format!("Failed to check status: {}", e))?;
            let resp_json: serde_json::Value = res.json().await.map_err(|e| e.to_string())?;
            let status_str = resp_json.get("status").and_then(|v| v.as_str()).unwrap_or("pending");
            return Ok(match status_str {
                "completed" => FiatStatus::Completed,
                "failed" => FiatStatus::Failed,
                "cancelled" => FiatStatus::Cancelled,
                _ => FiatStatus::Pending,
            });
        }
        Ok(FiatStatus::Pending)
    }
}