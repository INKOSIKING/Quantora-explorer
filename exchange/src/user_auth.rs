use serde::{Deserialize, Serialize};
use uuid::Uuid;
use chrono::{DateTime, Utc};
use argon2::{self, Config};
use rand::{distributions::Alphanumeric, Rng};
use totp_rs::{TOTP, Algorithm};
use jsonwebtoken::{encode, decode, Header, Validation, EncodingKey, DecodingKey};
use std::collections::HashMap;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct User {
    pub id: Uuid,
    pub email: String,
    pub password_hash: String,
    pub totp_secret: Option<String>,
    pub registered_at: DateTime<Utc>,
    pub last_login: Option<DateTime<Utc>>,
    pub is_active: bool,
    pub recovery_token: Option<String>,
    pub recovery_expiry: Option<DateTime<Utc>>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String,
    pub exp: usize,
}

pub struct AuthManager {
    pub users: HashMap<String, User>,
    pub jwt_secret: String,
}

impl AuthManager {
    pub fn new(jwt_secret: &str) -> Self {
        Self {
            users: HashMap::new(),
            jwt_secret: jwt_secret.to_string(),
        }
    }

    pub fn register_user(&mut self, email: &str, password: &str) -> Result<User, String> {
        if self.users.contains_key(email) {
            return Err("User already exists".to_string());
        }
        let password_hash = Self::hash_password(password)?;
        let user = User {
            id: Uuid::new_v4(),
            email: email.to_string(),
            password_hash,
            totp_secret: None,
            registered_at: Utc::now(),
            last_login: None,
            is_active: true,
            recovery_token: None,
            recovery_expiry: None,
        };
        self.users.insert(email.to_string(), user.clone());
        Ok(user)
    }

    pub fn hash_password(password: &str) -> Result<String, String> {
        let salt: String = rand::thread_rng()
            .sample_iter(&Alphanumeric)
            .take(16)
            .map(char::from)
            .collect();
        let config = Config::default();
        argon2::hash_encoded(password.as_bytes(), salt.as_bytes(), &config)
            .map_err(|e| format!("Password hash failed: {}", e))
    }

    pub fn verify_password(hash: &str, password: &str) -> bool {
        argon2::verify_encoded(hash, password.as_bytes()).unwrap_or(false)
    }

    pub fn login(&mut self, email: &str, password: &str, totp_code: Option<&str>) -> Result<String, String> {
        let user = self.users.get_mut(email).ok_or("User not found")?;
        if !Self::verify_password(&user.password_hash, password) {
            return Err("Invalid password".to_string());
        }
        if let Some(secret) = &user.totp_secret {
            let totp = TOTP::new(
                Algorithm::SHA1,
                6,
                1,
                30,
                secret.as_bytes().to_vec(),
            ).map_err(|e| format!("TOTP error: {:?}", e))?;
            let now = Utc::now().timestamp() as u64;
            if let Some(code) = totp_code {
                if !totp.check_current(code, now, 0) {
                    return Err("Invalid 2FA code".to_string());
                }
            } else {
                return Err("2FA code required".to_string());
            }
        }
        user.last_login = Some(Utc::now());
        let claims = Claims {
            sub: user.id.to_string(),
            exp: (Utc::now().timestamp() + 86400) as usize, // 1 day
        };
        encode(
            &Header::default(),
            &claims,
            &EncodingKey::from_secret(self.jwt_secret.as_ref()),
        ).map_err(|e| format!("JWT error: {}", e))
    }

    pub fn enable_2fa(&mut self, email: &str) -> Result<String, String> {
        let user = self.users.get_mut(email).ok_or("User not found")?;
        let secret: String = rand::thread_rng()
            .sample_iter(&Alphanumeric)
            .take(32)
            .map(char::from)
            .collect();
        user.totp_secret = Some(secret.clone());
        Ok(secret)
    }

    pub fn initiate_password_recovery(&mut self, email: &str) -> Result<String, String> {
        let user = self.users.get_mut(email).ok_or("User not found")?;
        let token: String = rand::thread_rng()
            .sample_iter(&Alphanumeric)
            .take(48)
            .map(char::from)
            .collect();
        let expiry = Utc::now() + chrono::Duration::minutes(30);
        user.recovery_token = Some(token.clone());
        user.recovery_expiry = Some(expiry);
        Ok(token)
    }

    pub fn reset_password(&mut self, email: &str, token: &str, new_password: &str) -> Result<(), String> {
        let user = self.users.get_mut(email).ok_or("User not found")?;
        if user.recovery_token.as_deref() != Some(token) {
            return Err("Invalid recovery token".to_string());
        }
        if let Some(expiry) = user.recovery_expiry {
            if Utc::now() > expiry {
                return Err("Recovery token expired".to_string());
            }
        } else {
            return Err("No recovery in progress".to_string());
        }
        user.password_hash = Self::hash_password(new_password)?;
        user.recovery_token = None;
        user.recovery_expiry = None;
        Ok(())
    }
}