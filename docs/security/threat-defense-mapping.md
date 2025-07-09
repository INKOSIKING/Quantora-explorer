# Threat-Informed Defense Mapping

| Technique            | Control/Detection | Coverage (Y/N) | Evidence Link                         |
|----------------------|------------------|----------------|---------------------------------------|
| Initial Access       | SSO, MFA, JIT    | Y              | [SSO Evidence](../ci/jit-access.yaml) |
| Privilege Escalation | RBAC, IAM scan   | Y              | [IAM Scan](../ci/priv-esc-paths.yaml) |
| Exfiltration        | DLP, Egress NP    | Y              | [DLP Policy](../k8s/egress-dlp-networkpolicy.yaml) |
| Lateral Movement     | Segmentation      | Y              | [Network Segmentation](../k8s/zero-trust-segmentation.yaml) |

*Update each row with latest controls and links to CI evidence/report artifacts.*