# Quantora Blockchain Node

This crate contains the core implementation of the Quantora blockchain node, including networking, consensus, storage, and API layers.

---

## Features

- **Consensus:** Pluggable proof-of-work (PoW) with adjustable difficulty.
- **Networking:** Lightweight peer-to-peer network for block and transaction propagation.
- **Storage:** Efficient and pluggable block/transaction storage.
- **APIs:** Extendable API endpoints (planned).
- **Testing & Benchmarks:** Comprehensive unit tests and Criterion benchmarks.

---

## Running

```sh
cargo run --release
```

---

## Modules

- `consensus.rs` — PoW consensus logic.
- `network.rs` — Peer management and messaging.
- `storage.rs` — Block and transaction persistence.
- `bench.rs` — Benchmarks for mining and storage.
- `tests/` — Unit tests for all components.

---

## Development

- All major logic is tested.
- Logging via `log` crate.
- To run benchmarks:
    ```sh
    cargo bench
    ```

---

## Extending

To implement new consensus or storage backends, follow the traits and patterns in the current modules.

---

## License

MIT