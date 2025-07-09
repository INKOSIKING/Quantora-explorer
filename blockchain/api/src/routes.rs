use actix_web::web;
use crate::handlers::{auth, user};

pub fn register_routes(cfg: &mut web::ServiceConfig) {
    cfg.service(auth::login)
       .service(auth::register)
       .service(user::get_profile);
}
