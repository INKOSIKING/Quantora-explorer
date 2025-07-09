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
# QuanX Blockchain

A high-performance blockchain implementation featuring the QuanX token with advanced tokenomics.

## 🪙 QuanX Token Specifications

- **Total Supply**: 20 Trillion QuanX
- **Burned Supply**: 4 Trillion QuanX (permanently locked, untouchable but affects price)
- **Founder Allocation**: 6 Trillion QuanX (your personal allocation)
- **Mining Pool**: 10 Trillion QuanX (available for miners)

## 🔑 Founder Wallet

Your founder wallet is automatically created with 6 trillion QuanX tokens. The seed phrase is displayed when you start the blockchain node.

**⚠️ IMPORTANT**: Save your seed phrase securely! This is the only way to access your 6 trillion QuanX tokens.

## 🚀 Getting Started

### Prerequisites
- Rust (latest stable version)
- Cargo

### Running the Blockchain

1. Navigate to the blockchain node directory:
```bash
cd blockchain-node
```

2. Start the blockchain:
```bash
cargo run --release
```

The blockchain will start and display:
- Your founder wallet seed phrase
- Wallet address
- Token distribution information
- API endpoints

## 🌐 API Endpoints

### Wallet Operations

- `GET /api/wallet/create` - Create a new wallet
- `GET /api/wallet/{address}` - Get wallet information
- `POST /api/wallet/transfer` - Transfer QuanX tokens
- `GET /api/founder` - Get founder wallet information
- `GET /api/stats` - Get blockchain statistics

### Example API Usage

#### Create a New Wallet
```bash
curl http://localhost:3000/api/wallet/create
```

#### Check Founder Wallet
```bash
curl http://localhost:3000/api/founder
```

#### Get Blockchain Stats
```bash
curl http://localhost:3000/api/stats
```

## ⛏️ Mining

Mining rewards start at 1000 QuanX per block and halve every 210,000 blocks. The mining pool contains 10 trillion QuanX tokens.

## 🔒 Security Features

- **Burned Supply Protection**: 4 trillion tokens are permanently locked
- **Cryptographic Security**: Uses secp256k1 elliptic curve cryptography
- **Proof of Work**: Secure consensus mechanism
- **Seed Phrase Generation**: BIP39 compliant wallet generation

## 🏗️ Architecture

- **Rust Backend**: High-performance blockchain core
- **RESTful API**: Easy integration with web and mobile apps
- **Modular Design**: Extensible for future features
- **Network Ready**: P2P networking capabilities

## 📊 Token Economics

The QuanX token implements a deflationary model:
- 4 trillion tokens permanently removed from circulation
- Mining rewards decrease over time
- Limited total supply creates scarcity

## 🔧 Configuration

The blockchain runs on:
- **P2P Network**: Port 8080
- **Web API**: Port 3000
- **Mining Difficulty**: Adjustable (starts at 4)

## 📱 Wallet Integration

The blockchain supports both custodial and non-custodial wallets:
- **Custodial**: Built-in API for web/app integration
- **Non-custodial**: BIP39 seed phrase compatibility
- **Multi-platform**: Web, mobile, and desktop support

## 🚀 Deployment

The blockchain is designed to run on Replit and can be easily deployed:

1. Clone this repository
2. Run `cargo run --release` in the blockchain-node directory
3. The blockchain and API will start automatically

## 📈 Future Features

- Smart contracts
- DeFi protocols
- NFT support
- Cross-chain bridges
- Mobile wallets

---

**Your QuanX journey starts here! 🚀**

Remember to save your founder wallet seed phrase - it's your key to 6 trillion QuanX tokens!
