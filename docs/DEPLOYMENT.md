# Quantora Deployment Guide

## Requirements

- Docker or Kubernetes cluster
- Ethereum Mainnet RPC endpoint (Infura, Alchemy, etc.)
- An Ethereum account whose private key is available as a secret

## Building and Running Locally

```bash
docker build -t quantora .
docker run -e ETH_RPC=https://mainnet.infura.io/v3/YOUR_KEY -e ETH_PRIVATE_KEY=YOUR_PRIVATE_KEY -p 8080:8080 quantora
```

## Using Docker Compose

```bash
export ETH_PRIVATE_KEY=your_private_key
docker-compose up --build
```

## Deploying to Kubernetes

1. Create a secret for your Ethereum private key:

    ```bash
    kubectl create secret generic eth-secrets --from-literal=ETH_PRIVATE_KEY=your_private_key
    ```

2. Apply the deployment and service:

    ```bash
    kubectl apply -f deploy/production.yaml
    ```

3. Expose the service (if needed):

    ```bash
    kubectl expose deployment quantora --type=LoadBalancer --port=8080
    ```

---

## Monitoring & Logging

- The Quantora binary logs to stdout/stderr. Use Kubernetes/Docker logging aggregation as needed.
- For production, use a log aggregator (ELK, Loki, etc.) and set up Prometheus scraping for health endpoints.

---

## Web/App Frontend

- The React app can be deployed separately (Vercel, Netlify, or your own server).
- Configure the frontend to point to the Quantora backend API endpoint.

---

## Security

- Keep your ETH private key secret.
- Use HTTPS for all endpoints (TLS termination at load balancer/proxy).