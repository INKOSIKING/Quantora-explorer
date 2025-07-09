# Quantora Chain: Validator Onboarding

## 1. Requirements

- 32,000,000 QTA minimum stake (configurable)
- Dedicated server (see deployment guide)
- Stable, high-speed Internet
- Latest Quantora node software

---

## 2. Steps

1. **Install and sync node** (see [deployment_and_monitoring.md](deployment_and_monitoring.md))
2. **Generate validator key**
   ```sh
   blockchain-node wallet create --validator
   ```
3. **Fund validator address** with minimum QTA (from wallet)
4. **Register as validator**
   ```sh
   blockchain-node staking register --address <your_validator_addr> --amount <stake>
   ```
5. **Monitor your status**
   - Use explorer or API: `getValidatorStatus`
   - Check rewards, penalties, uptime

---

## 3. Validator Operations

- Sign blocks and participate in consensus automatically
- Keep node online 24/7 for maximum rewards
- If slashed (for downtime or double-signing), stake may be reduced

---

## 4. Security

- Use HSM or hardware wallet for validator key
- Firewall API ports (do not expose signing endpoints)
- Regularly update node and monitor logs

---

## 5. Unbonding/Exit

- Unbond via CLI or API (unbond period applies, see config)
- After unbonding, stake is returned minus any penalties

---

## 6. Troubleshooting

- Check logs for consensus errors
- If jailed, resolve issue and re-activate with `staking unjail`
- For support, contact validators@quantora.org

---