-- ========================================================================
-- 🧩 Table: dapp_deployment_registry
-- 📘 Tracks all decentralized applications deployed in Quantora
-- ========================================================================

CREATE TABLE IF NOT EXISTS dapp_deployment_registry (
  dapp_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dapp_name            TEXT NOT NULL,
  developer_address    TEXT NOT NULL,
  deployment_block     BIGINT NOT NULL,
  contract_address     TEXT UNIQUE NOT NULL,
  source_code_url      TEXT,
  frontend_url         TEXT,
  category             TEXT, -- e.g., DeFi, GameFi, DAO, Utility
  uses_ai              BOOLEAN DEFAULT FALSE,
  ipfs_manifest_hash   TEXT,
  active               BOOLEAN DEFAULT TRUE,
  last_active_block    BIGINT,
  created_at           TIMESTAMPTZ DEFAULT now(),
  updated_at           TIMESTAMPTZ
);

-- 📌 Indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_contract_address ON dapp_deployment_registry(contract_address);
CREATE INDEX IF NOT EXISTS idx_dapp_category ON dapp_deployment_registry(category);
CREATE INDEX IF NOT EXISTS idx_dapp_active ON dapp_deployment_registry(active);
