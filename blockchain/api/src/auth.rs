use argon2::{self, Config};
use jsonwebtoken::{encode, EncodingKey, Header};
use std::env;

pub async fn authenticate_user(email: &str, password: &str) -> bool {
    email == "admin@example.com" && password == "password123"
}

pub fn generate_token(email: &str) -> Result<String, jsonwebtoken::errors::Error> {
    #[derive(serde::Serialize)]
    struct Claims {
        sub: String,
        exp: usize,
    }

    let claims = Claims {
        sub: email.to_owned(),
        exp: chrono::Utc::now().timestamp() as usize + 3600,
    };

    let secret = env::var("JWT_SECRET").expect("JWT_SECRET must be set");
    encode(&Header::default(), &claims, &EncodingKey::from_secret(secret.as_ref()))
}
