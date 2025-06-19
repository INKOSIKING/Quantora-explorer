use std::collections::{BTreeMap, VecDeque};
use uuid::Uuid;
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, PartialEq)]
pub enum OrderSide {
    Buy,
    Sell,
}

#[derive(Debug, Clone, PartialEq)]
pub enum OrderType {
    Limit,
    Market,
}

#[derive(Debug, Clone)]
pub struct Order {
    pub id: Uuid,
    pub user_id: Uuid,
    pub side: OrderSide,
    pub price: Option<f64>, // None for market
    pub qty: f64,
    pub filled: f64,
    pub order_type: OrderType,
    pub timestamp: DateTime<Utc>,
}

#[derive(Debug, Clone)]
pub struct Trade {
    pub id: Uuid,
    pub buy_order_id: Uuid,
    pub sell_order_id: Uuid,
    pub price: f64,
    pub qty: f64,
    pub timestamp: DateTime<Utc>,
}

pub struct OrderBook {
    pub bids: BTreeMap<f64, VecDeque<Order>>, // price => orders
    pub asks: BTreeMap<f64, VecDeque<Order>>, // price => orders
}

impl OrderBook {
    pub fn new() -> Self {
        Self {
            bids: BTreeMap::new(),
            asks: BTreeMap::new(),
        }
    }

    pub fn place_order(&mut self, mut order: Order) -> Vec<Trade> {
        let mut trades = vec![];
        match order.side {
            OrderSide::Buy => {
                // Match against asks (lowest price first)
                while order.qty > 0.0 {
                    let (ask_price, ask_queue_opt) = {
                        let mut iter = self.asks.iter_mut();
                        iter.next().map(|(p, q)| (*p, q))
                    }.unwrap_or((0.0, &mut VecDeque::new()));

                    if ask_queue_opt.is_empty() || (order.order_type == OrderType::Limit && order.price.unwrap() < ask_price) {
                        break;
                    }

                    let mut ask_order = ask_queue_opt.front_mut().unwrap();
                    let fill_qty = order.qty.min(ask_order.qty - ask_order.filled);
                    let execution_price = ask_price;

                    let trade = Trade {
                        id: Uuid::new_v4(),
                        buy_order_id: order.id,
                        sell_order_id: ask_order.id,
                        price: execution_price,
                        qty: fill_qty,
                        timestamp: Utc::now(),
                    };
                    trades.push(trade);

                    order.filled += fill_qty;
                    ask_order.filled += fill_qty;
                    order.qty -= fill_qty;

                    if ask_order.filled >= ask_order.qty {
                        ask_queue_opt.pop_front();
                    }
                    if ask_queue_opt.is_empty() {
                        self.asks.remove(&ask_price);
                    }
                }
                if order.qty > 0.0 && order.order_type == OrderType::Limit {
                    self.bids.entry(order.price.unwrap())
                        .or_insert_with(VecDeque::new)
                        .push_back(order);
                }
            },
            OrderSide::Sell => {
                // Match against bids (highest price first)
                while order.qty > 0.0 {
                    let (bid_price, bid_queue_opt) = {
                        let mut iter = self.bids.iter_mut().rev();
                        iter.next().map(|(p, q)| (*p, q))
                    }.unwrap_or((0.0, &mut VecDeque::new()));

                    if bid_queue_opt.is_empty() || (order.order_type == OrderType::Limit && order.price.unwrap() > bid_price) {
                        break;
                    }

                    let mut bid_order = bid_queue_opt.front_mut().unwrap();
                    let fill_qty = order.qty.min(bid_order.qty - bid_order.filled);
                    let execution_price = bid_price;

                    let trade = Trade {
                        id: Uuid::new_v4(),
                        buy_order_id: bid_order.id,
                        sell_order_id: order.id,
                        price: execution_price,
                        qty: fill_qty,
                        timestamp: Utc::now(),
                    };
                    trades.push(trade);

                    order.filled += fill_qty;
                    bid_order.filled += fill_qty;
                    order.qty -= fill_qty;

                    if bid_order.filled >= bid_order.qty {
                        bid_queue_opt.pop_front();
                    }
                    if bid_queue_opt.is_empty() {
                        self.bids.remove(&bid_price);
                    }
                }
                if order.qty > 0.0 && order.order_type == OrderType::Limit {
                    self.asks.entry(order.price.unwrap())
                        .or_insert_with(VecDeque::new)
                        .push_back(order);
                }
            }
        }
        trades
    }

    pub fn snapshot(&self) -> (Vec<(f64, f64)>, Vec<(f64, f64)>) {
        let bids = self.bids.iter()
            .rev()
            .map(|(p, orders)| (*p, orders.iter().map(|o| o.qty - o.filled).sum()))
            .collect();
        let asks = self.asks.iter()
            .map(|(p, orders)| (*p, orders.iter().map(|o| o.qty - o.filled).sum()))
            .collect();
        (bids, asks)
    }
}