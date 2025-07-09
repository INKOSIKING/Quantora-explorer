use actix_web::{post, web, HttpResponse};
use sqlx::PgPool;
use uuid::Uuid;

use crate::auth::{self, jwt, password::verify_password, LoginRequest, TokenResponse};
use crate::models::user::User;

#[post("/login")]
pub async fn login(data: web::Data<PgPool>, payload: web::Json<LoginRequest>) -> HttpResponse {
    let user: Option<User> = sqlx::query_as!(
        User,
        "SELECT * FROM users WHERE email = $1",
        payload.email
    )
    .fetch_optional(data.get_ref())
    .await
    .ok()
    .flatten();

    if let Some(user) = user {
        if verify_password(&user.password_hash, &payload.password) {
            let token = jwt::create_token(&user.id.to_string());
            return HttpResponse::Ok().json(TokenResponse { token });
        }
    }

    HttpResponse::Unauthorized().body("Invalid credentials")
}

#[post("/register")]
pub async fn register(data: web::Data<PgPool>, payload: web::Json<LoginRequest>) -> HttpResponse {
    let hash = auth::password::hash_password(&payload.password);
    let id = Uuid::new_v4();
    let res = sqlx::query!(
        "INSERT INTO users (id, email, password_hash) VALUES ($1, $2, $3)",
        id,
        payload.email,
        hash
    )
    .execute(data.get_ref())
    .await;

    match res {
        Ok(_) => HttpResponse::Created().body("User registered"),
        Err(_) => HttpResponse::InternalServerError().finish(),
    }
}
