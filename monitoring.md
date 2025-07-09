...
## Example Prometheus Alert Rules

```yaml
groups:
- name: explorer
  rules:
    - alert: IndexerSyncLag
      expr: max(api_indexer_tip) - max(api_node_tip) > 10
      for: 5m
      labels:
        severity: warning
      annotations:
        summary: "Indexer is lagging node by more than 10 blocks"

    - alert: ExplorerApiDown
      expr: up{job="explorer"} == 0
      for: 1m
      labels:
        severity: critical
      annotations:
        summary: "Explorer API is down"

    - alert: HighErrorRate
      expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
      for: 2m
      labels:
        severity: warning
      annotations:
        summary: "API 5xx error rate > 5% (last 5m)"
```
...