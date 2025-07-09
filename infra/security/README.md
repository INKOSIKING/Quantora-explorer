# Security Hardening Guide

- All secrets handled via Vault or KMS. No plaintext secrets in code, CI/CD or containers.
- All services enforce HTTPS and HSTS.
- mTLS is required for all intra-cluster communication.
- All container images are scanned, signed, and verified at deploy time.
- SAST, DAST, and dependency audit run on every PR and on schedule.
- Use signed commits and enable branch protection on all mainline branches.
- All admin and sensitive actions are logged. Logs are immutable and centralized.
- RBAC is enforced at both service and infrastructure level.
- All endpoints have rate-limiting, circuit breakers, and abuse prevention.
- All user data is encrypted at rest and in transit. Access is tightly controlled and audited.