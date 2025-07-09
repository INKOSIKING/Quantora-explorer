# Exchange Security Review Checklist

## Static & Dynamic Analysis
- [x] All dependencies scanned for CVEs on every CI run
- [x] Static analysis using clippy and cargo-audit
- [x] No unsafe Rust code used in business logic
- [x] Fuzzed matching engine and critical parsers

## Authentication & Access
- [x] Argon2 password hashing with unique salt per user
- [x] JWT session tokens, with short expiry and revocation on logout
- [x] 2FA/TOTP required for withdrawals and admin actions
- [x] Role-based access for operator/admin endpoints

## Blockchain & Fiat
- [x] Hot/cold wallet separation, HSM or ENV key protection
- [x] All fiat/crypto withdrawals require KYC and risk checks
- [x] Withdrawal queue requires manual review > threshold

## API & Web
- [x] All API inputs validated; never trust user input
- [x] WebSocket connections rate-limited and authenticated for private feeds
- [x] CORS, CSRF, and XSS protections enabled in all web endpoints

## Operations & Audit
- [x] All admin actions and withdrawals audit logged
- [x] All critical errors generate alerts and PagerDuty incident
- [x] Quarterly penetration testing (external vendor)

---

*All critical passing tests and checks are required before production deployments.  
See `tests/integration_tests.rs` and `tests/security_tests.rs` for code coverage.*