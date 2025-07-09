# Quantora Chain: Explorer Integration

## 1. Overview

Quantora provides a reference blockchain explorer and APIs for integrating third-party explorers.

---

## 2. Reference Explorer

- Open-source, see `explorer/` in the repo
- Live demo: https://explorer.quantora.org

### Features

- Block, transaction, and account search
- Live mempool and latest block stream
- Proposal and governance dashboard
- Contract and token browser
- Validator set and staking dashboard

---

## 3. Explorer API

- Uses the same JSON-RPC as the node, plus extra endpoints for stats and analytics
- REST endpoints for:
  - `/api/stats/txs-per-second`
  - `/api/stats/blocks-per-minute`
  - `/api/stats/supply`
  - `/api/governance/proposals`
  - `/api/validators`

---

## 4. Embedding Explorer Widgets

- iFrame widgets for live block stream, account balances, proposal status
- Example:
  ```html
  <iframe src="https://explorer.quantora.org/widget/latest-blocks" width="600" height="200"></iframe>
  ```

---

## 5. Third-Party Explorer Integration

- Use the node's JSON-RPC and REST APIs
- For advanced analytics, subscribe to WebSocket for real-time events
- OpenAPI spec available in `docs/api_openapi.yaml`

---

## 6. Custom Analytics

- Export blocks and transactions via `/api/blocks?from=...&to=...`
- Use Prometheus metrics for operator dashboards

---

## 7. Branding and Customization

- Fork the reference explorer for your own chain or testnet
- Themeable via CSS; replace logo, colors, etc.

---

## 8. Support

- PRs and issues welcome at `explorer/` repo
- Contact: explorer-support@quantora.org

---