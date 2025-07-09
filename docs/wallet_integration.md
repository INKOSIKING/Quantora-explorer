# Quantora Chain: User and Wallet Integration

## 1. Supported Wallets

- Quantora Node CLI wallet (reference implementation)
- JSON-RPC API (compatible with MetaMask-style wallets via custom network)
- Hardware wallets (Ledger, Trezor) via QTA app
- Web wallet (see `wallet/` in repo)

---

## 2. Creating/Importing Wallets

- Mnemonic phrase (BIP39) and direct private key import supported
- All keys encrypted on disk (no plain text)
- Optional password protection and 2FA for CLI/web

---

## 3. Sending Transactions

- Use wallet CLI, web wallet, or direct JSON-RPC API
- Nonce and fee auto-calculated by wallet
- All txs signed client-side; private key never leaves device

---

## 4. Receiving QTA

- Share your address (QTA1... format)
- Check for incoming txs via wallet UI or API

---

## 5. Viewing Balances & History

- Wallet and explorer show up-to-date balances and tx history
- All data also available via `getBalance` and `getTransaction` API calls

---

## 6. Contract Calls

- Wallet supports contract interaction (deploy, call, sign)
- ABI/autocomplete for major contract types
- Gas estimation and simulation built-in

---

## 7. Security

- Always back up your mnemonic/keystore
- Use hardware wallets for large balances
- Never share your private key or mnemonic

---

## 8. Integration API Example

```json
{
  "jsonrpc": "2.0",
  "method": "sendRawTransaction",
  "params": ["0x...signed_tx_hex"],
  "id": 1
}
```

---

## 9. Resources

- [Wallet download](https://quantora.org/wallet)
- [Developer docs](https://quantora.org/dev)
- [Support](mailto:support@quantora.org)

---