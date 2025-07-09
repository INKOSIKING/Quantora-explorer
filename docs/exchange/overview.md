# Quantora Exchange: System Overview

Quantora Exchange is a modular, high-performance cryptocurrency trading platform designed for seamless integration with the Quantora blockchain and fiat rails. It implements a robust order matching engine, secure user flows, compliance automation, and extensible APIs for both clients and operators.

---

## Core Modules

- **Matching Engine:** Centralized, in-memory order book and matching logic for spot markets.
- **Wallet/Node Integration:** Automated deposit/withdrawal flows with blockchain monitoring and internal hot/cold wallet management.
- **KYC/AML:** Pluggable integration with leading KYC/AML providers for onboarding and ongoing user checks.
- **Fiat Integration:** Connects to external payment providers for bank card, ACH, SEPA, and other rails.
- **User Account System:** Secure registration, login, 2FA, and recovery.
- **API Layer:** REST/WebSocket for trading, account, market data, and admin functions.
- **Admin Dashboard:** Operator console for monitoring, manual actions, and compliance.
- **Testing & Security:** Full coverage tests, CI, and continuous audit framework.

---

## Deployment Options

- Docker Compose (see `exchange/docker-compose.yaml`)
- Kubernetes (see `exchange/k8s/`)
- Bare metal (systemd, config docs)

---

*Each module is detailed in this documentation directory.*