use actix_web::{Responder, HttpResponse, web};
use sqlx::PgPool;
use uuid::Uuid;
use crate::db;
use serde::{Deserialize, Serialize};

// Deposit request (simulate deposit credit)
#[derive(Deserialize)]
pub struct DepositRequest {
    pub asset: String,
    pub amount: i64,
}

pub async fn deposit(
    pool: web::Data<PgPool>,
    user_id: Uuid,
    req: web::Json<DepositRequest>,
) -> impl Responder {
    let balance = db::get_balance(pool.get_ref(), user_id, &req.asset)
        .await
        .ok()
        .flatten()
        .map(|b| b.amount)
        .unwrap_or(0);
    let new_balance = balance + req.amount;
    match db::update_balance(pool.get_ref(), user_id, &req.asset, new_balance).await {
        Ok(_) => HttpResponse::Ok().body("Deposit credited"),
        Err(e) => HttpResponse::InternalServerError().body(format!("Error: {e}")),
    }
}

// Withdrawal request (simulate withdrawal request, deduct balance and mark as pending)
#[derive(Deserialize)]
pub struct WithdrawRequest {
    pub asset: String,
    pub amount: i64,
    pub withdrawal_address: String,
}

pub async fn withdraw(
    pool: web::Data<PgPool>,
    user_id: Uuid,
    req: web::Json<WithdrawRequest>,
) -> impl Responder {
    let balance = db::get_balance(pool.get_ref(), user_id, &req.asset)
        .await
        .ok()
        .flatten()
        .map(|b| b.amount)
        .unwrap_or(0);
    if balance < req.amount {
        return HttpResponse::BadRequest().body("Insufficient balance");
    }
    let new_balance = balance - req.amount;
    if let Err(e) = db::update_balance(pool.get_ref(), user_id, &req.asset, new_balance).await {
        return HttpResponse::InternalServerError().body(format!("Error: {e}"));
    }
    // In production: record withdrawal request, trigger custody system
    HttpResponse::Ok().body("Withdrawal requested and is pending approval")
}