# Quantora Exchange Backend – API Reference

## Authentication

### POST `/api/register`
Register a new user.
**Request:**
```json
{
  "email": "user@example.com",
  "password": "string"
}
```
**Response:**  
`200 OK`
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "registered_at": "2025-01-14T12:00:00Z",
    ...
  },
  "error": null
}
```

### POST `/api/login`
User login (with optional TOTP).
**Request:**
```json
{
  "email": "user@example.com",
  "password": "string",
  "totp_code": "optional"
}
```
**Response:**  
`200 OK`
```json
{
  "success": true,
  "data": "jwt_token_string",
  "error": null
}
```

## Orders

### POST `/api/order`
Place a new order.
**Request:**
```json
{
  "user_id": "uuid",
  "side": "buy" | "sell",
  "price": 123.45,        // null for market
  "qty": 1.0,
  "order_type": "limit" | "market"
}
```
**Response:**  
`200 OK`
```json
{
  "success": true,
  "data": [ /* list of trades filled */ ],
  "error": null
}
```

### GET `/api/orderbook`
Get snapshot of bids and asks.
**Response:**
```json
{
  "success": true,
  "data": [
    [ [price, qty], ... ], // bids
    [ [price, qty], ... ]  // asks
  ],
  "error": null
}
```

## WebSocket

### GET `/ws`
Upgrade to WebSocket for live orderbook/trade feed.
**On connect:**  
Orderbook snapshot is sent immediately:
```json
{
  "type": "OrderBookSnapshot",
  "payload": {
    "bids": [ [price, qty], ... ],
    "asks": [ [price, qty], ... ]
  }
}
```
**Heartbeat:**  
Ping/Pong every 5s.

## Admin API

All admin endpoints require JWT with `admin` or `operator` privileges.

### POST `/admin/user`
Get user details.
**Request:**  
```json
{ "user_id": "uuid" }
```

### POST `/admin/user/lock`
Lock a user.
**Request:**  
```json
{ "user_id": "uuid" }
```

### POST `/admin/kyc/override`
Override KYC status.
**Request:**  
```json
{ "user_id": "uuid", "new_status": "approved" | "rejected" | ... }
```

### GET `/admin/withdrawals/pending`
List pending withdrawals.

### POST `/admin/withdrawal/approve`
Approve a withdrawal.
**Request:**  
```json
{ "withdrawal_id": "uuid" }
```

### POST `/admin/withdrawal/reject`
Reject a withdrawal.
**Request:**  
```json
{ "withdrawal_id": "uuid" }
```

---

## Error Handling

All endpoints return `success`, `data`, and `error`.  
- `success: false` and `error` populated on failure.
- HTTP status codes reflect error category (400, 401, 404, 500, etc).

## Rate Limiting & Security

- All endpoints apply rate limiting (see deployment guide for nginx/Cloudflare config).
- JWT required for order placement, withdrawals, and all admin endpoints.
- 2FA mandatory for sensitive actions.

---

For further details, see individual module Rust docstrings or contact Quantora backend maintainers.