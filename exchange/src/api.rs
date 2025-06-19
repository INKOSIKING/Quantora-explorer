use actix_web::{Responder, HttpResponse, web};
use sqlx::PgPool;
use crate::{models::{User, Order}, db, auth, orderbook};
use serde::{Serialize, Deserialize};
use uuid::Uuid;
use log::error;

pub struct UserService;
pub struct OrderService;
pub struct MarketService;

#[derive(Deserialize)]
pub struct RegisterRequest {
    pub username: String,
    pub password: String,
}

#[derive(Serialize)]
pub struct RegisterResponse {
    pub username: String,
    pub jwt: String,
}

impl UserService {
    pub async fn register(
        pool: web::Data<PgPool>,
        secret: web::Data<String>,
        req: web::Json<RegisterRequest>,
    ) -> impl Responder {
        let hashed = auth::hash_password(&req.password);
        match db::create_user(pool.get_ref(), &req.username, &hashed).await {
            Ok(user) => {
                let jwt = auth::create_jwt(&user.username, secret.as_str());
                HttpResponse::Ok().json(RegisterResponse { username: user.username, jwt })
            }
            Err(_) => HttpResponse::BadRequest().body("Username taken"),
        }
    }

    pub async fn login(
        pool: web::Data<PgPool>,
        secret: web::Data<String>,
        req: web::Json<RegisterRequest>,
    ) -> impl Responder {
        match db::get_user_by_username(pool.get_ref(), &req.username).await {
            Ok(Some(user)) => {
                if auth::verify_password(&req.password, &user.hashed_password) {
                    let jwt = auth::create_jwt(&user.username, secret.as_str());
                    HttpResponse::Ok().json(RegisterResponse { username: user.username, jwt })
                } else {
                    HttpResponse::Unauthorized().body("Invalid credentials")
                }
            }
            _ => HttpResponse::Unauthorized().body("Invalid credentials"),
        }
    }
}

#[derive(Deserialize)]
pub struct PlaceOrderRequest {
    pub side: String, // "buy" or "sell"
    pub asset: String,
    pub price: i64,
    pub amount: i64,
}

#[derive(Serialize)]
pub struct PlaceOrderResponse {
    pub order_id: String,
    pub status: String,
}

impl OrderService {
    pub async fn place_order(
        pool: web::Data<PgPool>,
        secret: web::Data<String>,
        req: web::Json<PlaceOrderRequest>,
        jwt: Option<web::Header<String>>,
    ) -> impl Responder {
        let jwt = match jwt.as_ref().and_then(|h| h.get(7..)) {
            Some(token) => token,
            None => return HttpResponse::Unauthorized().body("Missing or invalid Authorization header"),
        };
        let claims = match auth::verify_jwt(jwt, secret.as_str()) {
            Some(claims) => claims,
            None => return HttpResponse::Unauthorized().body("Invalid JWT"),
        };
        // Fetch user
        let user = match db::get_user_by_username(pool.get_ref(), &claims.sub).await {
            Ok(Some(u)) => u,
            _ => return HttpResponse::Unauthorized().body("User not found"),
        };
        // For "buy" orders, check quote balance (e.g., "USDT"), for "sell", check asset balance
        let check_asset = if req.side == "buy" { "USDT" } else { &req.asset };
        let needed = if req.side == "buy" { req.price * req.amount } else { req.amount };
        let balance = db::get_balance(pool.get_ref(), user.id, check_asset).await.ok().flatten().map(|b| b.amount).unwrap_or(0);
        if balance < needed {
            return HttpResponse::BadRequest().body("Insufficient balance");
        }
        // Lock the funds (just subtract for now)
        if let Err(_) = db::update_balance(pool.get_ref(), user.id, check_asset, balance - needed).await {
            return HttpResponse::InternalServerError().body("Failed to lock funds");
        }
        // Place order
        let order = match db::create_order(pool.get_ref(), user.id, &req.side, &req.asset, req.price, req.amount).await {
            Ok(o) => o,
            Err(_) => return HttpResponse::InternalServerError().body("Failed to create order"),
        };
        HttpResponse::Ok().json(PlaceOrderResponse {
            order_id: order.id.to_string(),
            status: "open".to_string(),
        })
    }

    pub async fn orderbook(
        pool: web::Data<PgPool>,
        query: web::Query<std::collections::HashMap<String, String>>,
    ) -> impl Responder {
        let asset = query.get("asset").cloned().unwrap_or_else(|| "QTC".to_string());
        let buy_orders = db::get_open_orders(pool.get_ref(), &asset, "buy").await.unwrap_or_default();
        let sell_orders = db::get_open_orders(pool.get_ref(), &asset, "sell").await.unwrap_or_default();
        HttpResponse::Ok().json(serde_json::json!({
            "buy": buy_orders,
            "sell": sell_orders
        }))
    }
}

impl MarketService {
    // Simple batch matcher endpoint (demo; in production, run as background task)
    pub async fn match_orders(
        pool: web::Data<PgPool>,
        asset: web::Path<String>,
    ) -> impl Responder {
        let buy_orders = db::get_open_orders(pool.get_ref(), &asset, "buy").await.unwrap_or_default();
        let sell_orders = db::get_open_orders(pool.get_ref(), &asset, "sell").await.unwrap_or_default();
        let trades = orderbook::match_orders(buy_orders.clone(), sell_orders.clone());
        for trade in &trades {
            let _ = db::insert_trade(pool.get_ref(), trade).await;
            // Update order fills
            let buy_order = buy_orders.iter().find(|o| o.id == trade.buy_order_id).unwrap();
            let sell_order = sell_orders.iter().find(|o| o.id == trade.sell_order_id).unwrap();
            let new_buy_filled = buy_order.filled + trade.amount;
            let buy_status = if new_buy_filled >= buy_order.amount { "filled" } else { "open" };
            let new_sell_filled = sell_order.filled + trade.amount;
            let sell_status = if new_sell_filled >= sell_order.amount { "filled" } else { "open" };
            let _ = db::update_order_filled(pool.get_ref(), buy_order.id, new_buy_filled, buy_status).await;
            let _ = db::update_order_filled(pool.get_ref(), sell_order.id, new_sell_filled, sell_status).await;
            // Credit asset balances for buyer/seller
            let _ = db::update_balance(pool.get_ref(), buy_order.user_id, &buy_order.asset, trade.amount).await;
            let _ = db::update_balance(pool.get_ref(), sell_order.user_id, "USDT", trade.price * trade.amount).await;
        }
        HttpResponse::Ok().json(trades)
    }
}