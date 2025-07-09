-- File: migrations/003_create_accounts.sql

-- ✅ Create the "accounts" table
CREATE TABLE IF NOT EXISTS accounts (
  address        VARCHAR(66) PRIMARY KEY,           -- 0x-prefixed 40-byte hex (EVM-style)
  balance        NUMERIC(78, 0) NOT NULL DEFAULT 0, -- High precision for token values
  nonce          BIGINT NOT NULL DEFAULT 0,         -- Prevent replay attacks
  code_hash      VARCHAR(66),                       -- Optional hash of smart contract code
  storage_root   VARCHAR(66),                       -- Root hash for account's storage trie
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔁 Auto-update updated_at on changes
CREATE OR REPLACE FUNCTION update_accounts_updated_at() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_accounts_updated_at
BEFORE UPDATE ON accounts
FOR EACH ROW EXECUTE FUNCTION update_accounts_updated_at();

-- 🔍 Indexes for fast lookups
CREATE INDEX IF NOT EXISTS idx_accounts_balance ON accounts (balance);
CREATE INDEX IF NOT EXISTS idx_accounts_nonce ON accounts (nonce);

-- 🔒 Optional format constraint
ALTER TABLE accounts
  ADD CONSTRAINT chk_address_format CHECK (address ~ '^0x[a-fA-F0-9]{40}$');
