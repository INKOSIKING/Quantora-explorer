# Quantora Blockchain

## Structure

- `node/` - Blockchain node core (Rust)
- `api/` - Blockchain REST API (Rust/Actix)
- `mobile/` - React Native wallet

## Run

- `cd node && cargo run` (node)
- `cd api && cargo run` (API, requires node running)
- `cd mobile && expo start` (mobile app)

## API

- `/wallet/balance/{address}` - Get balance
- `/wallet/send` - Send
- `/tx/{hash}` - Get tx
- `/contract/call` - Contract call
- `/contract/deploy` - Deploy contract

## Production

- Use HTTPS and secure storage for production.