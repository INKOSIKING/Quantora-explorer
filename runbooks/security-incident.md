# Security Incident Runbook

## Detection
- Monitor for alerts from Falco, WAF, IDS, or Prometheus.

## Containment
- Isolate affected pods/nodes via `kubectl cordon/drain` and network policy.

## Eradication
- Rotate secrets and credentials via Vault.
- Patch and redeploy affected workloads.

## Recovery
- Verify logs and backups for tampering.
- Restore from known-good images and data.

## Lessons Learned
- Conduct post-mortem and update controls/runbooks.