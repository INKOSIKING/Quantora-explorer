# Quantora: Network-Ready Blockchain, Exchange, and Explorer

## Overview

Quantora is a production-ready, modular Rust workspace featuring:

- **Blockchain**: Account-based ledger, wallet, transactions, block mining, REST API.
- **Exchange**: User registration, JWT auth, asset balances, order book, trade matching, REST API.
- **Indexer**: Syncs blockchain data, provides fast search/stats via REST API.

## Deployment (Docker Compose)

1. **Clone and build**
   ```bash
   git clone <your-repo>
   cd Quantora
   cp .env.sample .env
   # Edit .env with your secrets and database settings
   ```

2. **Start everything**
   ```bash
   docker compose up --build
   ```

3. **Apply database schemas**
   - Use `psql` or any Postgres client to apply each `schema.sql` file to the corresponding DB (blockchain, exchange, indexer).

4. **APIs**

- **Blockchain API**:  
  - `POST /wallet/create`  
  - `GET /wallet/balance/{address}`  
  - `POST /wallet/send`  
  - `GET /tx/{tx_id}`  
  - `POST /block/mine`  
  - `POST /contract/deploy` (demo)  
  - `POST /contract/call` (demo)

- **Exchange API**:  
  - `POST /user/register`  
  - `POST /user/login`  
  - `POST /order/place`  
  - `GET /order/book?asset=QTC`  
  - `POST /market/match/{asset}`

- **Indexer API**:  
  - `GET /block/{hash}`  
  - `GET /tx/{tx_id}`  
  - `GET /blocks/recent`  
  - `GET /txs/recent`  
  - `GET /stats`

## Configuration

- All services use environment variables for secrets and DB URLs (`.env` file).
- All services listen on `0.0.0.0` for network deployment.

## Scaling

- Use Docker Compose for orchestration.
- Adjust the number of workers, DB size, etc. as needed for your environment.

## Security

- JWT authentication for user endpoints.
- CORS enabled for API access.
- Use HTTPS and secure your secrets for production.

---

**Enjoy your production-ready Quantora stack!**
