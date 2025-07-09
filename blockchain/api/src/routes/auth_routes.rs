use actix_web::{post, web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use crate::auth::{authenticate_user, generate_token};

#[derive(Deserialize, Serialize, utoipa::ToSchema)]
pub struct LoginRequest {
    pub email: String,
    pub password: String,
}

#[derive(Serialize, utoipa::ToSchema)]
pub struct LoginResponse {
    pub token: String,
}

#[post("/login")]
pub async fn login(data: web::Json<LoginRequest>) -> impl Responder {
    if authenticate_user(&data.email, &data.password).await {
        let token = generate_token(&data.email).unwrap();
        HttpResponse::Ok().json(LoginResponse { token })
    } else {
        HttpResponse::Unauthorized().body("Invalid credentials")
    }
}

pub fn config(cfg: &mut web::ServiceConfig) {
    cfg.service(login);
}
