# Quantora Chain Documentation

## Sections

- [Node Operation Guide](node_operation.md)
- [API Reference & OpenAPI Schema](api_openapi.yaml)
- [Advanced Node Configuration](node_config_advanced.md)
- [Security Audits & Bug Fixes](security_audit_and_bugfix.md)
- [Audit Reports](audit_reports/)
- [Changelog](CHANGELOG.md)

## Quick Start

1. Build:  
   `cargo build --release`
2. Run:  
   `./target/release/blockchain-node --config node-config.toml`
3. See [node_operation.md](node_operation.md) for full details.

## Security

- All modules (consensus, state, network, API) are continuously fuzzed and audited.
- See [audit_reports/](audit_reports/) for full security reports.

## Contributing

- Open a pull request for fixes or features.
- Security issues: see [security_audit_and_bugfix.md](security_audit_and_bugfix.md).

## License

MIT or Apache 2.0 (choose in your repo).