-- =============================================================================
-- 🧩 Table: dapp_registry
-- �� Registry of dApps deployed on Quantora with metadata and audit trail
-- =============================================================================

CREATE TABLE IF NOT EXISTS dapp_registry (
  dapp_id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dapp_name               TEXT NOT NULL,
  contract_address        TEXT NOT NULL,
  version                 TEXT DEFAULT '1.0.0',
  deployed_by             TEXT NOT NULL,
  deploy_tx_hash          TEXT NOT NULL,
  deployed_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_updated_at         TIMESTAMPTZ,
  description             TEXT,
  category                TEXT CHECK (category IN ('DeFi', 'GameFi', 'NFT', 'DAO', 'Infra', 'Social', 'Utility', 'Other')),
  website_url             TEXT,
  github_url              TEXT,
  audit_status            TEXT DEFAULT 'unknown' CHECK (audit_status IN ('unknown', 'audited', 'pending', 'rejected')),
  audit_report_url        TEXT,
  icon_url                TEXT,
  is_open_source          BOOLEAN DEFAULT TRUE,
  chain_id                TEXT NOT NULL,
  tags                    TEXT[],
  UNIQUE(contract_address)
);

-- ⚡ Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_name ON dapp_registry(dapp_name);
CREATE INDEX IF NOT EXISTS idx_dapp_category ON dapp_registry(category);
CREATE INDEX IF NOT EXISTS idx_dapp_deployer ON dapp_registry(deployed_by);
CREATE INDEX IF NOT EXISTS idx_dapp_status ON dapp_registry(audit_status);
