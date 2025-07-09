# Production Deployment Guide for Quantora Exchange Backend

## 1. Security & Compliance Prerequisites

- [ ] All tests, security, and integration suites passing
- [ ] Audit logs enabled, admin access RBAC enforced
- [ ] JWT/2FA secrets, DB creds, and signing keys in a secure vault (not in env files or code)
- [ ] Admin and withdrawal approval flows tested with real operator accounts
- [ ] All API endpoints behind reverse proxy (nginx, Caddy, or AWS ALB)
- [ ] TLS/SSL enforced on all ingress
- [ ] Static code and dependency audit (cargo-audit, clippy, SAST)

## 2. Environment Variables Checklist

| Variable                  | Purpose                  | Example/Notes                          |
|---------------------------|--------------------------|----------------------------------------|
| JWT_SECRET                | User session signing key | Required, 32+ chars, never in code     |
| DB_URL                    | Database connection      | Postgres/MySQL, connection URI         |
| STRIPE_API_KEY            | Fiat onramp/offramp      | Needed for Stripe/Circle integration   |
| QUANTORA_NODE_URL         | Blockchain node endpoint | Local or cloud Quantora node           |
| KYC_PROVIDER_API_KEY      | KYC/AML provider         | E.g. Sumsub, Onfido, Persona           |

*(Set all in a secrets manager or CI/CD secret store.)*

## 3. Build & Run

```bash
# Build release binary
cargo build --release

# Set environment variables (example)
export JWT_SECRET='yourlongsupersecretkeyhere'
export DB_URL='postgres://user:pw@localhost:5432/quantora'
export STRIPE_API_KEY='sk_live_...'
export QUANTORA_NODE_URL='https://node.quantora.io'
export KYC_PROVIDER_API_KEY='kyc_key_...'
# ... add as needed

# Start the server
./target/release/exchange
```

## 4. Systemd Service Example

```ini
[Unit]
Description=Quantora Exchange Backend
After=network.target

[Service]
Type=simple
User=exchange
WorkingDirectory=/opt/quantora
ExecStart=/opt/quantora/target/release/exchange
Environment=JWT_SECRET=yourlongsupersecretkeyhere
Environment=DB_URL=postgres://user:pw@localhost:5432/quantora
Restart=on-failure
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
```

## 5. Health Checks & Monitoring

- `/api/orderbook` and `/api/login` can be used for basic liveness probe
- Prometheus metrics endpoint (add with Actix middleware for prod ops)
- Integrate with PagerDuty or preferred alerting for error monitoring

## 6. Scaling, Backups & Disaster Recovery

- Scale backend via multiple Actix workers or containers (stateless except DB/wallet)
- DB must be on SSD, daily logical backups, WAL archiving
- Blockchain node: always run your own for withdrawal/funding reliability
- For fiat, webhooks must be received on a public endpoint (use ngrok for dev)

## 7. Updating

- Pull latest tags from VCS
- Run full regression/integration suite
- Deploy via blue/green or rolling upgrade (never in-place for prod)
- Always test admin and withdrawal flows after deploy

---

**For further hardening:**
- Add WAF and rate limiting (nginx, Cloudflare)
- Enable mTLS for inter-service calls
- Quarterly pen-test, bug bounty program

---