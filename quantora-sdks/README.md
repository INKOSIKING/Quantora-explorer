# Quantora SDK Suite: Production-Ready, Cross-Platform

## Overview

The Quantora SDK Suite is a comprehensive, production-grade, multi-language developer toolkit for building wallets, exchanges, dApps, DeFi, staking, trading bots, and integrations with the Quantora blockchain and DeFi ecosystem.

**All SDKs are:**
- Idiomatic per-language and framework
- Fully typed, robust, and extensible
- Offer complete coverage: REST, GraphQL, gRPC, event streaming, wallet, tx, exchange, staking, governance, DeFi, and utility modules
- Released, versioned, CI-tested, and published to official package repositories

## Supported SDKs

- TypeScript / JavaScript (Node, browser, React Native)
- Python (sync & asyncio, web/data science)
- Go
- Rust
- Java (Android, server, JVM)
- Kotlin
- Swift (iOS, macOS)
- C# (.NET, Unity)
- C++ (desktop, embedded, HFT)
- Dart (Flutter)
- Scala
- Elixir
- Haskell
- Ruby
- PHP
- R
- Julia
- Bash (CLI, scripting)
- Powershell
- MATLAB
- Objective-C
- Lua
- Perl
- Clojure
- WebAssembly (WASM, JS interop)
- GraphQL codegen for all supported languages
- gRPC/protobuf codegen for all supported languages

## Features (All SDKs)

- Full API coverage (REST, GraphQL, gRPC)
- Wallet management: create, import, export, sign, hardware wallet/MPC/multisig where available
- Transaction builder/broadcast: all tx types, all supported VMs
- Advanced exchange/trading: swaps, orderbook, market/limit, batch, streaming
- Staking, DeFi, governance: all primitives
- Event subscription/streaming: websockets, hooks, gRPC streams
- Auth: JWT, OAuth, WalletConnect, hardware, biometric
- Multi-network: testnet, mainnet, custom
- Robust error handling, retries, logging
- Typed, tested, documented, production-ready
- Automated codegen, CI/CD, versioning, docs

## Directory Structure

```
quantora-sdks/
├── typescript/
│   ├── src/
│   │   ├── rest.ts
│   │   ├── graphql.ts
│   │   ├── grpc.ts
│   │   ├── wallet.ts
│   │   ├── tx.ts
│   │   ├── exchange.ts
│   │   ├── staking.ts
│   │   ├── governance.ts
│   │   ├── defi.ts
│   │   ├── eventstream.ts
│   │   ├── auth.ts
│   │   └── utils.ts
│   ├── tests/
│   └── package.json
├── python/
│   ├── quantora/
│   │   ├── rest.py
│   │   ├── graphql.py
│   │   ├── grpc.py
│   │   ├── wallet.py
│   │   ├── tx.py
│   │   ├── exchange.py
│   │   ├── staking.py
│   │   ├── governance.py
│   │   ├── defi.py
│   │   ├── eventstream.py
│   │   ├── auth.py
│   │   └── utils.py
│   ├── tests/
│   └── setup.py
├── go/
│   ├── rest.go
│   ├── graphql.go
│   ├── grpc.go
│   ├── wallet.go
│   ├── tx.go
│   ├── exchange.go
│   ├── staking.go
│   ├── governance.go
│   ├── defi.go
│   ├── eventstream.go
│   ├── auth.go
│   └── utils.go
│   ├── tests/
│   └── go.mod
├── rust/
│   ├── src/
│   │   ├── lib.rs
│   │   ├── rest.rs
│   │   ├── graphql.rs
│   │   ├── grpc.rs
│   │   ├── wallet.rs
│   │   ├── tx.rs
│   │   ├── exchange.rs
│   │   ├── staking.rs
│   │   ├── governance.rs
│   │   ├── defi.rs
│   │   ├── eventstream.rs
│   │   ├── auth.rs
│   │   └── utils.rs
│   ├── tests/
│   └── Cargo.toml
# ...repeat for all SDKs/languages
├── devops/
│   ├── ci.yml
│   ├── publish_all.sh
│   └── codegen/
├── README.md
```

## Automation

- **OpenAPI, GraphQL, Protobuf schemas** are versioned and used for automatic code generation and coverage validation
- **CI/CD**: Every SDK is linted, tested, and built for every commit
- **Publishing**: All SDKs are published to their respective registries (npm, PyPI, crates.io, Maven, NuGet, pub.dev, Hex, etc.) on release
- **Docs**: Centralized docs and per-language quickstart, API reference, and examples

## Contributing

1. Choose your language.
2. Follow the module conventions: rest, graphql, grpc, wallet, tx, exchange, staking, governance, defi, eventstream, auth, utils.
3. Write idiomatic, robust, fully-tested code.
4. Pull requests are CI-validated and must not reduce coverage or break compatibility.
5. See [CONTRIBUTING.md](./CONTRIBUTING.md) for details.

---