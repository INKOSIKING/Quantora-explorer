# Matching Engine & Order Book

## 1. Architecture

- Written in Rust (highly concurrent), can be ported to Go/C++ for performance
- Central in-memory order book per market (instrument)
- Atomic order placement/cancel/match
- WebSocket for real-time feeds

---

## 2. Core Concepts

- **Order:** {id, user_id, side, price, quantity, type, status, timestamp}
- **Order Book:** bid/ask trees (sorted by price/time)
- **Trade:** {id, buy_order_id, sell_order_id, price, quantity, timestamp}
- **Matching:** Price/time priority; supports limit, market, IOC, FOK types

---

## 3. Example (Simplified) Order Match

```rust
// Pseudocode
fn place_order(order: Order) -> Vec<Trade> {
    let trades = Vec::new();
    if order.side == Buy {
        while let Some(best_ask) = order_book.best_ask() {
            if order.price >= best_ask.price {
                // Match, fill qty, emit trade
            } else { break; }
        }
    } else {
        while let Some(best_bid) = order_book.best_bid() {
            if order.price <= best_bid.price {
                // Match, fill qty, emit trade
            } else { break; }
        }
    }
    // Insert remainder into book if not filled/cancelled
    trades
}
```

---

## 4. Persistence & Recovery

- Engine state checkpointed to disk or database for crash recovery
- Replay event log (trades, cancels, places) to rebuild book

---

## 5. API Endpoints

- `POST /orders` Place new order
- `DELETE /orders/:id` Cancel
- `GET /orderbook/:pair` Current book snapshot
- WebSocket: `wss://.../feed` (live trades, book updates)

---

## 6. Failure Handling

- Atomic state transitions
- Rollback on error
- All actions logged/audited

---