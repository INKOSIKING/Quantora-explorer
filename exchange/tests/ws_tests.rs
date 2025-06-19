use actix_web::{test, App};
use exchange::matching_engine::OrderBook;
use exchange::ws::ws_routes;
use std::sync::{Arc, Mutex};

#[actix_web::test]
async fn test_ws_upgrade() {
    let order_book = Arc::new(Mutex::new(OrderBook::new()));
    let app =
        test::init_service(App::new().configure(|cfg| ws_routes(cfg, order_book.clone()))).await;

    let req = test::TestRequest::with_uri("/ws")
        .insert_header(("upgrade", "websocket"))
        .to_request();
    let resp = test::call_service(&app, req).await;
    assert_eq!(resp.status().as_u16(), 101); // Switching Protocols
}
