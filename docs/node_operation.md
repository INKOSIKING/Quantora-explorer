# Quantora Chain Node Operation Guide

## 1. Running a Node

### Prerequisites
- Rust stable toolchain (latest)
- Open required TCP ports (default: 30303 for P2P, 8545 for API)
- Sufficient hardware (multi-core CPU, SSD, 64GB+ RAM for mainnet)

### Install & Build
```sh
git clone https://github.com/yourorg/quantora-chain.git
cd quantora-chain/blockchain-node
cargo build --release
```

### Start Node
```sh
./target/release/blockchain-node --config node-config.toml
```

### Example config (`node-config.toml`)
```toml
[network]
listen_addr = "0.0.0.0:30303"
bootnodes = ["1.2.3.4:30303", "5.6.7.8:30303"]

[chain]
genesis_file = "genesis.json"
data_dir = "quantora-data"
consensus = "pow" # or "pos"
```

### Peer Discovery
- Node auto-discovers peers using TCP handshake.
- You can manually add peers via CLI or config.

### Common CLI Flags
| Flag              | Description                       |
|-------------------|-----------------------------------|
| --config <file>   | Path to config file               |
| --genesis <file>  | Genesis block file                |
| --data-dir <dir>  | Blockchain state/data directory   |
| --listen <addr>   | Listen address for P2P            |
| --api <addr>      | JSON-RPC HTTP API bind address    |
| --log-level <lvl> | Log verbosity ("info", "debug")   |

---

## 2. API Reference

### JSON-RPC Overview
- HTTP POST or WebSocket
- Default port: 8545
- Accepts JSON payloads

### Common Methods

| Method                  | Params                                    | Returns               | Description                          |
|-------------------------|-------------------------------------------|-----------------------|--------------------------------------|
| `getBlockByHash`        | `hash`                                    | `Block`               | Get block by hash                    |
| `getBlockByNumber`      | `number`                                  | `Block`               | Get block by number                  |
| `getTransaction`        | `tx_hash`                                 | `Transaction`         | Get transaction by hash              |
| `sendRawTransaction`    | `raw_tx_hex`                              | `tx_hash`             | Submit signed transaction            |
| `getBalance`            | `address`                                 | `u64`                 | Current balance for address          |
| `getNonce`              | `address`                                 | `u64`                 | Current nonce for address            |
| `getPeers`              | none                                      | `[PeerInfo]`          | Connected peers                      |
| `getStatus`             | none                                      | `StatusInfo`          | Node status and health               |
| `callContract`          | `contract, method, params`                | `Result`              | Read-only contract call              |
| `estimateGas`           | `transaction`                             | `u64`                 | Gas estimation for transaction       |

### Example Request
```json
POST / HTTP/1.1
Host: 127.0.0.1:8545
Content-Type: application/json

{
  "jsonrpc": "2.0",
  "method": "getBalance",
  "params": ["QTA1..."],
  "id": 1
}
```

### Example Response
```json
{
  "jsonrpc": "2.0",
  "result": 1000000000,
  "id": 1
}
```

---

## 3. Operating Best Practices

- Keep your node software up-to-date.
- Regularly back up data directory and keys.
- Monitor node logs and resource usage.
- Use a firewall and only expose needed ports.
- For validators/miners: use a dedicated, secure machine.

---

## 4. Troubleshooting

- **Node not syncing:** Check network connectivity and peer count.
- **High resource usage:** Ensure sufficient hardware and SSDs.
- **API not responding:** Confirm API port is open and node is running.
- **Peer issues:** Add more bootnodes or check firewall/NAT.

---

## 5. More

- Full API and schema: see `docs/api_openapi.yaml`
- Advanced config: see `docs/node_config_advanced.md`
- Community/Support: [Discord invite], [Telegram link], [Docs site]