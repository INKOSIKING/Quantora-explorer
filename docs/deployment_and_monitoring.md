# Quantora Chain: Deployment and Monitoring Guide

## 1. Deployment

### On-Premise / Self-hosted

1. **System Requirements**
   - 16+ CPU cores (64-bit)
   - 64 GB+ RAM (production mainnet)
   - High-speed NVMe SSD
   - Linux (Ubuntu 22.04 LTS or newer), also supports macOS and Windows for dev/test

2. **Install Dependencies**
   ```sh
   sudo apt update && sudo apt install build-essential pkg-config libssl-dev git
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source $HOME/.cargo/env
   cargo install --locked --force cargo-audit
   ```

3. **Build Node**
   ```sh
   git clone https://github.com/yourorg/quantora-chain.git
   cd quantora-chain/blockchain-node
   cargo build --release
   ```

4. **Start Node**
   ```sh
   ./target/release/blockchain-node --config node-config.toml
   ```

5. **Set Up Systemd Service (Recommended)**
   ```ini
   [Unit]
   Description=Quantora Node
   After=network.target

   [Service]
   ExecStart=/path/to/blockchain-node --config /path/to/node-config.toml
   Restart=on-failure
   LimitNOFILE=4096

   [Install]
   WantedBy=multi-user.target
   ```
   - Place this file in `/etc/systemd/system/quantora-node.service` and run:
   ```sh
   sudo systemctl daemon-reload
   sudo systemctl enable --now quantora-node
   ```

---

## 2. Docker Deployment

1. **Build Docker Image**
   ```sh
   docker build -t quantora-node .
   ```

2. **Run Container**
   ```sh
   docker run -d --name qta-node \
     -v /my/host/data:/data \
     -p 30303:30303 -p 8545:8545 \
     quantora-node --config /data/node-config.toml
   ```

---

## 3. Monitoring

### Metrics

- Built-in Prometheus metrics endpoint (enable in config)
- Key metrics:
  - `qta_block_height`
  - `qta_peer_count`
  - `qta_txpool_size`
  - `qta_tps`

### Logs

- Logs to stdout by default; file output configurable
- Supports log levels: error, warn, info, debug, trace
- Example integration:  
  ```sh
  journalctl -u quantora-node -f
  tail -f /var/log/quantora-node.log
  ```

### Alerts

- Integrate with Grafana/Prometheus for alerting (e.g. block stall, peer drop)
- Sentry integration for error tracking (set Sentry DSN in config)

---

## 4. Health Checks

- `/healthz` HTTP endpoint returns 200 OK when node is healthy
- `getStatus` JSON-RPC: returns syncing, latest block, peer count, etc.

---

## 5. Backup and Restore

- Backup the `data_dir` regularly (hot/cold, with node stopped for full safety)
- Encrypt and integrity-check all backups
- To restore, copy backup to `data_dir` and restart node

---

## 6. Upgrades

- Always test new releases on a testnet node first
- For zero-downtime: run two nodes behind a load balancer and upgrade one at a time
- Use `cargo audit` to check for dependency CVEs before deploying

---

## 7. Cloud/Cluster Deployment

- Recommended: Kubernetes or Nomad for orchestration
- Use stateful sets for persistent storage
- Example K8s YAML and Helm charts: see `k8s/` (include in your repo)

---

## 8. Support

- For deployment help, contact devops@quantora.org or join the [community Discord].
