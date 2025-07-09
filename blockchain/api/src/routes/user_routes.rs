use actix_web::{get, HttpResponse, Responder, web};

#[get("/profile")]
pub async fn get_profile() -> impl Responder {
    HttpResponse::Ok().json({ "message": "user profile secured" })
}

pub fn config(cfg: &mut web::ServiceConfig) {
    cfg.service(get_profile);
}
