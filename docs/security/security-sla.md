# Security SLAs & Escalation Policy

## Severity Definitions
- **Critical:** Exploitable vulnerability with public access or sensitive data exposure.
- **High:** Privilege escalation or broad impact but not directly exploitable.
- **Medium:** Potential information disclosure or lateral movement.
- **Low:** Minor misconfigurations or best-practice gaps.

## Response Times
| Severity  | Initial Response | Triage/Remediate | Closure  |
|-----------|-----------------|------------------|----------|
| Critical  | 1 hour          | 24 hours         | 2 days   |
| High      | 4 hours         | 48 hours         | 7 days   |
| Medium    | 1 business day  | 5 days           | 14 days  |
| Low       | 2 business days | 1 month          | 2 months |

## Escalation
- On call: security@quantora.com, Slack #sec-alerts, PagerDuty escalation.
- All incidents logged in SIEM and ticketed in Jira/SecOps.