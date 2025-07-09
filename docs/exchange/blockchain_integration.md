# Blockchain Node Integration

## 1. Deposit Flow

- User generates deposit address (unique per user/asset, derived from hot wallet)
- Node monitors blockchain (Quantora and others) for inbound txs
- On confirmation, credit user's balance in exchange DB

## 2. Withdrawal Flow

- User requests withdrawal (UI/API)
- Exchange debits user account after risk checks
- Transaction signed (HSM or hot wallet), broadcast to node
- Monitor for confirmation, update status

## 3. Hot/Cold Wallet Design

- Hot wallet for small/fast withdrawals, cold wallet for storage
- Automated hot/cold rebalancing, admin approval for large moves
- Full key management and audit trails

## 4. Node Integration

- Uses Quantora node API (`getBalance`, `sendRawTransaction`, etc.)
- Support for multi-chain (BTC, ETH, QTA, etc.)

## 5. Security

- Withdrawals require 2FA and risk scoring
- Rate limits, AML checks before sending

---