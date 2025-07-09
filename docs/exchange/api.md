# Quantora Exchange API Reference

## 1. REST Endpoints

### Market Data

- `GET /markets`
- `GET /orderbook/:pair`
- `GET /trades/:pair`

### Trading

- `POST /orders` (place)
- `DELETE /orders/:id` (cancel)
- `GET /orders` (open orders)
- `GET /orders/history`

### Account

- `GET /account/balance`
- `GET /account/deposits`
- `GET /account/withdrawals`
- `POST /account/withdraw`

### KYC/AML

- `POST /kyc/start`
- `GET /kyc/status`

### Admin

- `GET /admin/users`
- `GET /admin/withdrawals/pending`
- `POST /admin/users/:id/lock`

## 2. WebSocket

- `wss://.../feed`
  - Real-time trades
  - Order book updates
  - User fills/notifications (authenticated)

## 3. Auth

- All private endpoints require JWT or session cookie

## 4. Docs

- OpenAPI/Swagger spec: `exchange/api_openapi.yaml`

---