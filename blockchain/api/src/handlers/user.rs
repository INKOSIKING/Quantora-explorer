use actix_web::{get, HttpRequest, HttpResponse};
use crate::auth::jwt::decode_token;

#[get("/profile")]
pub async fn get_profile(req: HttpRequest) -> HttpResponse {
    if let Some(auth_header) = req.headers().get("Authorization") {
        if let Ok(auth_str) = auth_header.to_str() {
            if auth_str.starts_with("Bearer ") {
                let token = &auth_str[7..];
                if let Some(claims) = decode_token(token) {
                    return HttpResponse::Ok().body(format!("User ID: {}", claims.sub));
                }
            }
        }
    }
    HttpResponse::Unauthorized().body("Missing or invalid token")
}
