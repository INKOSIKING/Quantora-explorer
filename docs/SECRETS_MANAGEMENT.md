# Secrets Management for Production

## Recommended Approach

- Use Doppler, HashiCorp Vault, or your cloud provider's secrets manager.
- Inject secrets as environment variables at container startup.
- Never commit secrets or production .env files.

## Example: Doppler with Kubernetes

1. Install Doppler CLI in your deployment pipeline or base image.
2. In your deployment YAML, add:

```yaml
command: ["doppler", "run", "--", "npm", "start"]
env:
  DOPPLER_TOKEN: ${DOPPLER_TOKEN}
```

3. Store secrets in Doppler dashboard, mapped to `EXCHANGE_JWT_SECRET`, `SENTRY_DSN`, `KYC_SUMSUB_KEY`, etc.

## Example: HashiCorp Vault

- Use [vault-k8s](https://www.vaultproject.io/docs/platform/k8s) injector to mount secrets as envs in pods.

## Verification

- Check logs for “missing env var” errors.
- Add runtime checks: fail fast if a critical secret is missing.