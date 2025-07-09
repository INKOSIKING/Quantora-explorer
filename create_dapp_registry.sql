-- ============================================================
-- 📦 Table: dapp_registry
-- Description: Registry of deployed dApps on the Quantora chain
-- ============================================================

CREATE TABLE IF NOT EXISTS dapp_registry (
    dapp_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                TEXT NOT NULL,
    description         TEXT,
    creator_address     TEXT NOT NULL,
    contract_address    TEXT UNIQUE NOT NULL,
    github_repo_url     TEXT,
    website_url         TEXT,
    category            TEXT,
    is_active           BOOLEAN DEFAULT TRUE,
    deployed_at_block   BIGINT,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_registry_creator ON dapp_registry(creator_address);
CREATE INDEX IF NOT EXISTS idx_dapp_registry_contract_addr ON dapp_registry(contract_address);
CREATE INDEX IF NOT EXISTS idx_dapp_registry_category ON dapp_registry(category);
