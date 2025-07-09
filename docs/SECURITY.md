# Quantora Security Checklist

### Authentication/Authorization

- [x] JWT tokens, short expiry, refresh flow
- [x] Optional MFA (TOTP)
- [x] Role-based guards for admin endpoints

### Secrets

- [x] All secrets loaded from secure vault (not plain .env in prod)
- [x] No secrets in code or logs

### Input Validation

- [x] class-validator (NestJS), Pydantic/Zod (Python/TS)
- [x] All API params and bodies validated

### Rate Limiting

- [x] Redis-backed distributed throttling

### Error Handling

- [x] All errors sanitized (no stack traces to user)
- [x] Sentry for all unhandled exceptions

### Database

- [x] All sensitive operations in transactions
- [x] No raw queries with user input

### Monitoring

- [x] Sentry + Prometheus connected
- [x] Metrics endpoint protected

### KYC/AML

- [x] Real provider integration (Sumsub/Onfido)
- [x] Webhook signature validation

### Dependencies

- [x] Automated Dependabot and Snyk scans

### Deployment

- [x] K8s with readiness/liveness probes
- [x] Blue/green and rollback ready

---

## For any box unchecked, see [DEPLOYMENT.md](./DEPLOYMENT.md) before going live.