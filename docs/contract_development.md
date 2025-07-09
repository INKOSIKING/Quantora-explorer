# Quantora Chain: Smart Contract Development

## 1. Supported Languages

- Rust (native, using `quantora-sdk`)
- Solidity (EVM compatible layer, optional)
- WebAssembly (Wasm)

---

## 2. Setup

- Install `quantora-sdk` (Rust crates)
- For Solidity, use Remix or Hardhat with custom RPC

---

## 3. Writing a Contract (Rust Example)

```rust
use quantora_sdk::{contract, env};

#[contract]
pub struct MyToken {
    pub total: u64,
}

#[contract]
impl MyToken {
    pub fn new() -> Self {
        Self { total: 0 }
    }
    pub fn mint(&mut self, amount: u64) {
        self.total += amount;
        env::log(format!("Minted {}", amount));
    }
}
```

---

## 4. Deploying

- Compile with `quantora-sdk` CLI:  
  `quantora-sdk build --release`
- Deploy via wallet or API:
  - Wallet: "Deploy contract" button
  - API: `sendRawTransaction` with deployment payload

---

## 5. Interacting

- Use wallet UI, CLI, or API (`callContract`, `sendRawTransaction`)
- Contract state and methods auto-discovered by ABI

---

## 6. Testing

- Write unit tests in Rust or Solidity
- Use `quantora-sdk test` or Hardhat test suite

---

## 7. Auditing

- Always audit contracts before deployment
- Use static analysis tools (Clippy, Slither, etc.)

---

## 8. Resources

- [SDK docs](https://quantora.org/sdk)
- [Contract templates](https://quantora.org/contracts)
- [Audit checklist](security_audit_and_bugfix.md)

---