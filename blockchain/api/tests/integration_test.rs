#[actix_rt::test]
async fn health_check_works() {
    use actix_web::{test, App};
    use blockchain_api::{config, db, middleware, routes};

    let cfg = config::Config::from_env();
    let pool = db::init_db(&cfg).await;
    let app = test::init_service(middleware::apply(
        App::new()
            .app_data(actix_web::web::Data::new(pool))
            .configure(routes::configure),
    ))
    .await;

    let req = test::TestRequest::get().uri("/health").to_request();
    let resp = test::call_service(&app, req).await;
    assert!(resp.status().is_success());
}
