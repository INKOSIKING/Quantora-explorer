-- =========================
-- Table: use_accounts
-- Purpose: User-linked wallet accounts & metadata
-- =========================

-- Table Definition
CREATE TABLE IF NOT EXISTS use_accounts (
  account_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL,
  wallet_address   VARCHAR(66) NOT NULL,
  is_primary       BOOLEAN NOT NULL DEFAULT FALSE,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_use_accounts_user ON use_accounts(user_id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_use_accounts_wallet ON use_accounts(wallet_address);

-- Trigger Function: updated_at auto-set
CREATE OR REPLACE FUNCTION fn_update_use_accounts_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
DROP TRIGGER IF EXISTS trg_use_accounts_updated_at ON use_accounts;
CREATE TRIGGER trg_use_accounts_updated_at
BEFORE UPDATE ON use_accounts
FOR EACH ROW
EXECUTE FUNCTION fn_update_use_accounts_updated_at();

-- Constraint: wallet address format
ALTER TABLE use_accounts
  ADD CONSTRAINT IF NOT EXISTS chk_wallet_addr_format
  CHECK (wallet_address ~ '^0x[a-fA-F0-9]{40}$');
