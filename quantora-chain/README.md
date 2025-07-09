# Quantora Chain

Quantora Chain is a modular, production-ready blockchain framework supporting multiple smart contract platforms including Solidity (EVM), Move, and WASM. It is designed for flexibility, security, and high performance, enabling developers to build custom blockchains or DApps with ease.

---

## Features

- **Multi-language Smart Contract Support:** Solidity (EVM), Move, WASM.
- **Pluggable Consensus:** Supports proof-of-work (PoW) and can be extended.
- **Modular Architecture:** Easily extend or replace core components.
- **Robust Networking:** Peer discovery, message propagation, and secure connections.
- **Efficient Storage:** Block and transaction storage with optional database backends.
- **Comprehensive Testing and Benchmarking:** Built-in unit tests and benchmarks.

---

## Repository Structure

- `blockchain-node/` — Core node implementation, consensus, networking, and storage.
- `contracts/` — Example and reference smart contracts in Solidity, Move, and WASM.
- `docs/` — Additional documentation, guides, and specifications.

---

## Quick Start

1. **Build the Node**
    ```sh
    cd blockchain-node
    cargo build --release
    ```

2. **Run the Node**
    ```sh
    ./target/release/quantora-node
    ```

3. **Deploy Contracts**
    - Solidity: Use any EVM-compatible deployment tool.
    - Move: Use Move CLI.
    - WASM: Use compatible toolchain for uploading WASM contracts.

---

## Example Contracts

- **ERC20 Token** — `contracts/erc20.sol`
- **NFT (WASM)** — `contracts/nft.wasm`
- **DAO (Move)** — `contracts/dao.move`

---

## Community & Contributions

Contributions are welcome! Please open issues or pull requests. See the [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## License

MIT