# Fiat On/Off Ramp Integration

## 1. Providers Supported

- Stripe, Circle, PrimeTrust, Wyre, Mercury, etc.
- Bank transfer support: SEPA, ACH, SWIFT

## 2. Deposit Flow

- User requests deposit, receives unique reference/code
- Provider API notifies backend on receipt
- User balance credited after confirmation

## 3. Withdrawal Flow

- User requests withdrawal, enters bank details
- Provider API called; user notified when payout arrives

## 4. Security & Compliance

- All fiat moves subject to KYC/AML checks
- Suspicious activity flagged for review

## 5. Accounting

- Real-time fiat balances, reconciliation dashboard

---