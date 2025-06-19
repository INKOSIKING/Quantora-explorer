use chrono::Utc;
use exchange::matching_engine::*;
use uuid::Uuid;

#[test]
fn test_basic_match() {
    let mut book = OrderBook::new();
    let user1 = Uuid::new_v4();
    let user2 = Uuid::new_v4();

    // Place a sell order
    let sell_order = Order {
        id: Uuid::new_v4(),
        user_id: user1,
        side: OrderSide::Sell,
        price: Some(100.0),
        qty: 1.0,
        filled: 0.0,
        order_type: OrderType::Limit,
        timestamp: Utc::now(),
    };
    book.place_order(sell_order);

    // Place a matching buy order
    let buy_order = Order {
        id: Uuid::new_v4(),
        user_id: user2,
        side: OrderSide::Buy,
        price: Some(100.0),
        qty: 1.0,
        filled: 0.0,
        order_type: OrderType::Limit,
        timestamp: Utc::now(),
    };
    let trades = book.place_order(buy_order);
    assert_eq!(trades.len(), 1);
    assert_eq!(trades[0].price, 100.0);
    assert_eq!(trades[0].qty, 1.0);

    // No orders left in book
    let (bids, asks) = book.snapshot();
    assert_eq!(bids.len(), 0);
    assert_eq!(asks.len(), 0);
}
