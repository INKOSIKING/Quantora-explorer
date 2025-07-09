-- ============================================================================
-- 📲 Table: dapp_interaction_ledger
-- 📘 Records every user interaction with DApps
-- ============================================================================

CREATE TABLE IF NOT EXISTS dapp_interaction_ledger (
  interaction_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_address     TEXT NOT NULL,
  dapp_id            UUID NOT NULL REFERENCES dapps(dapp_id) ON DELETE CASCADE,
  contract_address   TEXT NOT NULL,
  method_invoked     TEXT NOT NULL,
  input_payload      JSONB,
  tx_hash            TEXT,
  interaction_status TEXT CHECK (interaction_status IN ('pending', 'confirmed', 'failed')) DEFAULT 'pending',
  gas_used           BIGINT,
  block_number       BIGINT,
  interacted_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📌 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_interaction_wallet ON dapp_interaction_ledger(wallet_address);
CREATE INDEX IF NOT EXISTS idx_dapp_interaction_dapp_id ON dapp_interaction_ledger(dapp_id);
CREATE INDEX IF NOT EXISTS idx_dapp_interaction_status ON dapp_interaction_ledger(interaction_status);
CREATE INDEX IF NOT EXISTS idx_dapp_interaction_block_number ON dapp_interaction_ledger(block_number);
