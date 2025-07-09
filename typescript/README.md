# Quantora TypeScript SDK

Production-ready, fully typed, robust SDK for Quantora blockchain and DeFi.

## Features

- Full REST, GraphQL, gRPC coverage
- Wallet management (create, import, sign)
- Transaction builder
- Exchange/trading
- Staking, DeFi, governance
- Event streaming
- Auth (JWT, OAuth, WalletConnect, etc.)
- Robust error handling, retries, logging
- Typed, tested, documented

## Usage

```ts
import { QuantoraRestClient, QuantoraWallet, QuantoraExchange } from 'quantora-sdk';

const client = new QuantoraRestClient('https://api.quantora.io', 'API_KEY');
const wallet = QuantoraWallet.createRandom();
const exchange = new QuantoraExchange(client);

client.getAssets().then(console.log);
exchange.placeOrder({ user: wallet.address(), pair: 'BTC/USDT', side: 'buy', price: '60000', amount: '0.01', type: 'limit' });