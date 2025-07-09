use actix_web::{web, HttpResponse, Responder};

pub async fn get_balance(path: web::Path<String>) -> impl Responder {
    let address = path.into_inner();
    // Fetch the balance for the address.
    HttpResponse::Ok().json(serde_json::json!({
        "address": address,
        "balance": "100.0"
    }))
}