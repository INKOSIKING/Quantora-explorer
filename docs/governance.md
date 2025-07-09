# Quantora Chain: Governance

## 1. Overview

Quantora Chain is governed by an on-chain DAO (Decentralized Autonomous Organization) and a technical steering committee. Major changes require on-chain proposals and token-holder voting.

---

## 2. DAO Voting Process

1. **Proposal Submission**
   - Anyone can submit a proposal (protocol upgrade, treasury spending, parameter change) via the `submitProposal` API.
   - Proposals require a deposit (to prevent spam).

2. **Discussion & Review**
   - Proposals are visible via the block explorer and discussed in the [Governance Forum].
   - Technical committee may review and comment.

3. **Voting**
   - Voting is open to all QTA holders via the wallet or CLI.
   - Voting period: 7 days (default).
   - Votes are weighted by token balance at snapshot block.

4. **Enactment**
   - Passed proposals are queued for execution after a timelock (2 days, configurable).
   - On-chain logic enacts approved parameter or code changes.

---

## 3. Proposal Types

- **Protocol upgrades** (hard/soft forks)
- **Parameter changes** (block size, gas limits, rewards)
- **Treasury spending**
- **Grant allocations**
- **Committee member elections/removals**

---

## 4. Emergency Procedures

- Emergency shutdown/rollback may be invoked by a 2/3 supermajority of the technical committee and DAO, in case of critical bugs or attacks.
- All emergency actions are logged and auditable.

---

## 5. Transparency

- All proposals, votes, and enactments are recorded on-chain.
- Monthly transparency reports published at [quantora.org/reports].

---

## 6. Governance Smart Contracts

- See `contracts/Governance.sol` or `contracts/governance.rs` for contract details.
- Audited and open source.

---

## 7. Dispute Resolution

- Disputes are first mediated by the technical committee.
- If unresolved, a DAO-wide vote is held.

---

## 8. Upgrade Path

- All protocol upgrades are backwards compatible where feasible.
- Node operators are notified via on-chain events and mailing lists.

---

## 9. Community Participation

- Join the [Governance Forum] or community calls.
- Delegate your vote or participate directly.

---