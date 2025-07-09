use actix_web::{dev::{ServiceRequest, ServiceResponse}, Error};
use actix_web_httpauth::extractors::bearer::BearerAuth;
use futures::future::{ok, err, Ready};
use crate::auth::jwt;

pub fn jwt_validator(req: ServiceRequest, cred: BearerAuth) -> Ready<Result<ServiceRequest, (Error, ServiceRequest)>> {
    let token = cred.token();
    let secret = req.app_data::<actix_web::web::Data<String>>().map(|s| s.get_ref().clone()).unwrap();
    match jwt::verify_jwt(token, &secret) {
        Ok(_) => ok(req),
        Err(_) => err((actix_web::error::ErrorUnauthorized("Invalid token"), req)),
    }
}
