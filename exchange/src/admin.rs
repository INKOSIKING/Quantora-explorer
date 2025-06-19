use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use crate::kyc_aml::{KycStatus, KycRecord};
use crate::blockchain_integration::{WithdrawalRequest, WithdrawalStatus};
use crate::user_auth::User;
use std::collections::{HashMap, VecDeque};
use std::sync::{Arc, Mutex};

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct AdminUser {
    pub id: Uuid,
    pub email: String,
    pub role: AdminRole,
    pub is_active: bool,
    pub last_login: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize, Clone, PartialEq, Eq)]
pub enum AdminRole {
    SuperAdmin,
    Compliance,
    Support,
    Operator,
}

#[derive(Default)]
pub struct AdminDashboard {
    pub users: Arc<Mutex<HashMap<Uuid, User>>>,
    pub admin_users: Arc<Mutex<HashMap<Uuid, AdminUser>>>,
    pub kyc_records: Arc<Mutex<HashMap<Uuid, KycRecord>>>,
    pub withdrawal_queue: Arc<Mutex<VecDeque<WithdrawalRequest>>>,
}

impl AdminDashboard {
    pub fn new() -> Self {
        Self::default()
    }

    // User search and flagging
    pub fn get_user(&self, user_id: Uuid) -> Option<User> {
        let users = self.users.lock().unwrap();
        users.get(&user_id).cloned()
    }

    pub fn lock_user(&self, user_id: Uuid) -> bool {
        let mut users = self.users.lock().unwrap();
        if let Some(user) = users.get_mut(&user_id) {
            user.is_active = false;
            return true;
        }
        false
    }

    // KYC status update and audit
    pub fn kyc_status(&self, user_id: Uuid) -> Option<KycStatus> {
        let kyc = self.kyc_records.lock().unwrap();
        kyc.get(&user_id).map(|rec| rec.status.clone())
    }

    pub fn override_kyc(&self, user_id: Uuid, new_status: KycStatus) -> bool {
        let mut kyc = self.kyc_records.lock().unwrap();
        if let Some(rec) = kyc.get_mut(&user_id) {
            rec.status = new_status;
            return true;
        }
        false
    }

    // Withdrawals: review, approve, reject
    pub fn pending_withdrawals(&self) -> Vec<WithdrawalRequest> {
        let queue = self.withdrawal_queue.lock().unwrap();
        queue.iter().filter(|w| w.status == WithdrawalStatus::Pending).cloned().collect()
    }

    pub fn approve_withdrawal(&self, withdrawal_id: Uuid) -> bool {
        let mut queue = self.withdrawal_queue.lock().unwrap();
        if let Some(req) = queue.iter_mut().find(|w| w.id == withdrawal_id && w.status == WithdrawalStatus::Pending) {
            req.status = WithdrawalStatus::Processing;
            return true;
        }
        false
    }

    pub fn reject_withdrawal(&self, withdrawal_id: Uuid) -> bool {
        let mut queue = self.withdrawal_queue.lock().unwrap();
        if let Some(req) = queue.iter_mut().find(|w| w.id == withdrawal_id && w.status == WithdrawalStatus::Pending) {
            req.status = WithdrawalStatus::Cancelled;
            return true;
        }
        false
    }

    // Admin login and RBAC (role-based access control)
    pub fn admin_login(&self, email: &str) -> Option<AdminUser> {
        let admins = self.admin_users.lock().unwrap();
        admins.values().find(|a| a.email == email && a.is_active).cloned()
    }
}