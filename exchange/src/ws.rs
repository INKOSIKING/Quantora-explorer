#[derive(Serialize, Deserialize)]
pub enum WsEvent {
    Trade {
        market: String,
        price: i64,
        amount: i64,
        buy_order_id: uuid::Uuid,
        sell_order_id: uuid::Uuid,
    },
    OrderBookUpdate {
        market: String,
        side: String,
        price: i64,
        amount: i64,
    },
    // ...other events...
}