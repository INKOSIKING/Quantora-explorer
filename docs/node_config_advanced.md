# Advanced Node Configuration

## Network

- **listen_addr**: P2P listen address (`0.0.0.0:30303`)
- **bootnodes**: Array of initial nodes to connect for discovery
- **max_peers**: Max peer connections (default: 64)
- **nat**: NAT traversal (auto, none, upnp)

## Chain

- **genesis_file**: Path to genesis block JSON
- **data_dir**: Blockchain DB location
- **pruning**: State pruning strategy (full, archive, custom)
- **consensus**: "pow" or "pos"

## API

- **api_addr**: HTTP API listen address (`127.0.0.1:8545`)
- **cors**: Cross-origin domains allowed
- **jwt_secret**: API authentication secret (optional)

## Logging

- **log_level**: "info", "debug", "trace"
- **log_file**: Path for log output (optional)
- **metrics**: Enable Prometheus metrics (true/false)
- **sentry_dsn**: Sentry error tracking DSN (optional)

## Security

- **keystore_dir**: Directory for encrypted keys
- **require_password**: true/false for key unlock
- **allow_unsafe_rpc**: Never enable on mainnet!

## Example
```toml
[network]
listen_addr = "0.0.0.0:30303"
bootnodes = ["1.2.3.4:30303", "5.6.7.8:30303"]
max_peers = 128
nat = "upnp"

[chain]
genesis_file = "genesis.json"
data_dir = "data"
pruning = "archive"
consensus = "pow"

[api]
api_addr = "127.0.0.1:8545"
cors = ["*"]
jwt_secret = "supersecret"

[logging]
log_level = "info"
log_file = "quantora.log"
metrics = true
sentry_dsn = ""

[security]
keystore_dir = "keystore"
require_password = true
allow_unsafe_rpc = false
```