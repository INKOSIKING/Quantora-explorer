#!/bin/bash
NAMESPACE=mainnet
STATEFULSET=quantora-validator
kubectl -n $NAMESPACE get pods -l app=$STATEFULSET -o json | jq -r '.items[] | "\(.metadata.name) \(.status.phase)"' | while read pod phase; do
  if [[ "$phase" != "Running" ]]; then
    echo "[WARN] $pod not healthy, restarting..."
    kubectl -n $NAMESPACE delete pod $pod
  fi
done