# Quantora Chain: Advanced Kubernetes Deployment

- For high-availability, use at least 3 replicas.
- Use node anti-affinity to ensure pods are on distinct nodes:
```yaml
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values:
                - quantora-node
        topologyKey: "kubernetes.io/hostname"
```
- Use separate PersistentVolumeClaims per replica for independent state.
- Integrate with an external Prometheus and set up alerts for block lag, low peer count, or abnormal TPS.