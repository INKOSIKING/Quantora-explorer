use actix_cors::Cors;
use actix_web::middleware::{Logger, NormalizePath};
use actix_web::App;

pub fn apply(app: App) -> App {
    app
    .wrap(Logger::default())
    .wrap(NormalizePath::trim())
    .wrap(
        Cors::default()
            .allow_any_origin()
            .allow_any_method()
            .allow_any_header()
            .supports_credentials()
    )
}
