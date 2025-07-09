use actix_web::{Responder, HttpResponse, web};
use std::sync::Mutex;
use base64;

pub async fn deploy_contract(req: web::Json<String>) -> impl Responder {
    // Dummy implementation
    HttpResponse::Ok().body("Deployed")
}

pub async fn call_contract(req: web::Json<String>) -> impl Responder {
    // Dummy implementation
    HttpResponse::Ok().body("Contract called")
}
