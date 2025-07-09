# Quantora Developer Security Knowledge Base

## Secure Coding
- Validate and sanitize all user input.
- Use HTTPS and verify all TLS endpoints.
- Fetch secrets from Vault, never hard-code them.
- Avoid using deprecated or weak cryptographic algorithms.

## Incident Response
- If you see suspicious activity, immediately notify #sec-alerts.
- Use the runbooks in `runbooks/security-incident.md`.

## Testing
- All merges to main must pass SAST, DAST, dependency, and secret scanning.
- Run `make security-test` locally before PRs.

## LLM/AI
- Never pass user input directly to a model without guardrails.
- Use `prompt_guard.py` for all LLM endpoints.

## Reporting Vulnerabilities
- Email security@quantora.com or open a confidential GitHub Security Advisory.

_Last updated: 2025-06-13_