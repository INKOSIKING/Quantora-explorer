# Quantora Exchange Backend

Exchange backend in NestJS with JWT/MFA, strong validation, distributed rate limiting, Sentry/Prometheus, and KYC.

## Features

- JWT + MFA authentication
- Rate limiting with Redis
- Sentry and Prometheus integration
- KYC integration (Sumsub/Onfido-ready)
- Modular: wallet, order, trade, referral, loyalty, audit

## Environment

See `.env.example` for all config vars, including JWT secret, DB, Sentry, Redis, and KYC provider keys.

## Local Run

```bash
cp .env.example .env
npm install
npm run start:dev
```

## Production

- Use Doppler/HashiCorp Vault for secrets
- Use K8s manifests from `/k8s`
- Set up Sentry DSN and Prometheus scraping
- See `../../docs/DEPLOYMENT.md`