use chrono::{Utc, DateTime};
use serde::{Serialize, Deserialize};
use std::fs::File;
use std::io::Write;

#[derive(Serialize, Deserialize, Debug)]
pub struct KycRecord {
    pub user_id: String,
    pub kyc_level: String,
    pub status: String,
    pub reviewed_at: DateTime<Utc>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct TransactionLog {
    pub tx_id: String,
    pub user_id: String,
    pub tx_type: String,
    pub amount: f64,
    pub asset: String,
    pub timestamp: DateTime<Utc>,
    pub suspicious: bool,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SuspiciousActivityReport {
    pub user_id: String,
    pub reason: String,
    pub tx_id: Option<String>,
    pub reported_at: DateTime<Utc>,
}

pub fn generate_sar(user_id: &str, reason: &str, tx_id: Option<&str>) {
    let sar = SuspiciousActivityReport {
        user_id: user_id.to_owned(),
        reason: reason.to_owned(),
        tx_id: tx_id.map(|s| s.to_owned()),
        reported_at: Utc::now(),
    };
    let mut file = File::create(format!("compliance/sar_{}_{}.json", user_id, Utc::now().timestamp()))
        .expect("Cannot create SAR file");
    file.write_all(serde_json::to_string_pretty(&sar).unwrap().as_bytes()).unwrap();
    // Alert compliance team, log in secure storage...
}

pub fn log_transaction(log: &TransactionLog) {
    let mut file = File::create(format!("compliance/txlog_{}_{}.json", log.user_id, log.tx_id))
        .expect("Cannot create tx log");
    file.write_all(serde_json::to_string_pretty(&log).unwrap().as_bytes()).unwrap();
}

pub fn export_kyc_report(records: &[KycRecord]) {
    let mut file = File::create("compliance/kyc_report.csv").unwrap();
    writeln!(file, "user_id,kyc_level,status,reviewed_at").unwrap();
    for rec in records {
        writeln!(file, "{},{},{},{}", rec.user_id, rec.kyc_level, rec.status, rec.reviewed_at).unwrap();
    }
}