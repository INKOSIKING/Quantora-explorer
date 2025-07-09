mod config;
mod db;
mod auth;
mod handlers;
mod models;
mod middleware;
mod routes;
mod errors;

use actix_web::{App, HttpServer, middleware::Logger};
use dotenvy::dotenv;
use config::get_config;
use db::init_db;
use routes::register_routes;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

#[derive(OpenApi)]
#[openapi(
    paths(
        handlers::auth::login,
        handlers::auth::register,
        handlers::user::get_profile
    ),
    components(schemas = [models::user::User, auth::LoginRequest]),
    tags(
        (name = "Auth", description = "Authentication endpoints"),
        (name = "User", description = "User endpoints")
    )
)]
struct ApiDoc;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    env_logger::init();
    let cfg = get_config();
    let pool = init_db(&cfg.database_url).await;

    HttpServer::new(move || {
        App::new()
            .wrap(Logger::default())
            .app_data(actix_web::web::Data::new(pool.clone()))
            .configure(register_routes)
            .service(SwaggerUi::new("/docs").url("/api-doc/openapi.json", ApiDoc::openapi()))
    })
    .bind(("0.0.0.0", cfg.port))?
    .run()
    .await
}
