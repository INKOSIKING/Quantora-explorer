CREATE TABLE IF NOT EXISTS pending_transactions (
  tx_hash          VARCHAR(66) PRIMARY KEY, -- Unique transaction hash
  from_address     VARCHAR(66) NOT NULL,
  to_address       VARCHAR(66),
  nonce            BIGINT NOT NULL,
  gas_price        NUMERIC(78, 0) NOT NULL,
  gas_limit        BIGINT NOT NULL,
  value            NUMERIC(78, 0) NOT NULL,
  input_data       BYTEA,
  timestamp        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  status           TEXT NOT NULL DEFAULT 'pending', -- pending | dropped | replaced
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🧠 Auto-update `updated_at`
CREATE OR REPLACE FUNCTION update_pending_txs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_pending_txs_updated_at
BEFORE UPDATE ON pending_transactions
FOR EACH ROW
EXECUTE FUNCTION update_pending_txs_updated_at();

-- 🔍 Indexes for speed
CREATE INDEX IF NOT EXISTS idx_pending_txs_from ON pending_transactions (from_address);
CREATE INDEX IF NOT EXISTS idx_pending_txs_nonce ON pending_transactions (nonce);
CREATE INDEX IF NOT EXISTS idx_pending_txs_status ON pending_transactions (status);

-- 🔒 Address format validation
ALTER TABLE pending_transactions
  ADD CONSTRAINT chk_tx_hash_format CHECK (tx_hash ~ '^0x[a-fA-F0-9]{64}$'),
  ADD CONSTRAINT chk_from_address_format CHECK (from_address ~ '^0x[a-fA-F0-9]{40}$'),
  ADD CONSTRAINT chk_to_address_format CHECK (to_address ~ '^0x[a-fA-F0-9]{40}$');
