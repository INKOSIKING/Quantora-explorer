#!/bin/bash
set -e
NS="exchange"
DEPLOYMENT="exchange-api"
NEW_IMAGE="$1"
kubectl -n $NS scale deployment $DEPLOYMENT-green --replicas=3 || kubectl -n $NS apply -f deploy/k8s/${DEPLOYMENT}-green.yaml
kubectl -n $NS set image deployment/$DEPLOYMENT-green api-container=$NEW_IMAGE
sleep 60  # Replace with healthcheck loop
kubectl -n $NS patch svc exchange-api --patch '{"spec":{"selector":{"app":"exchange-api-green"}}}'
kubectl -n $NS scale deployment $DEPLOYMENT --replicas=0
echo "Blue-green upgrade complete."