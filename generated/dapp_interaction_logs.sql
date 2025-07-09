-- =====================================================================
-- 🧩 Table: dapp_interaction_logs
-- 📡 Tracks all interactions users have with on-chain decentralized apps
-- =====================================================================

CREATE TABLE IF NOT EXISTS dapp_interaction_logs (
  interaction_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dapp_name            TEXT NOT NULL,
  dapp_contract        TEXT NOT NULL,
  user_address         TEXT NOT NULL,
  function_called      TEXT NOT NULL,
  parameters           JSONB,
  value_sent           NUMERIC(78, 0) DEFAULT 0,
  tx_hash              TEXT NOT NULL,
  block_number         BIGINT NOT NULL,
  success              BOOLEAN NOT NULL,
  gas_used             BIGINT,
  timestamp            TIMESTAMPTZ NOT NULL,
  source_chain         TEXT,
  interface_type       TEXT, -- e.g., Web3.js, Ethers.js, WalletConnect
  metadata             JSONB,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 🧭 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_contract ON dapp_interaction_logs(dapp_contract);
CREATE INDEX IF NOT EXISTS idx_dapp_user ON dapp_interaction_logs(user_address);
CREATE INDEX IF NOT EXISTS idx_dapp_tx_hash ON dapp_interaction_logs(tx_hash);
CREATE INDEX IF NOT EXISTS idx_dapp_block ON dapp_interaction_logs(block_number);
