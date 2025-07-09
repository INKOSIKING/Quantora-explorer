-- ─────────────────────────────────────────────────────────────────────────────
-- 🔄 META_CONTRACT_VERSIONS — Tracks upgrades, patches, and variant deployment versions of smart contracts
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_contract_versions (
    version_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_address VARCHAR(66) NOT NULL,
    version_tag      TEXT NOT NULL,
    compiler_version TEXT,
    source_hash      TEXT,
    deployment_block BIGINT,
    changelog        TEXT,
    created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_contract_version_address ON meta_contract_versions(contract_address);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🌐 EXPLORER_UI_METADATA — Dynamic UI instructions for contracts and tokens
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS explorer_ui_metadata (
    ui_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_address VARCHAR(66),
    ui_schema        JSONB NOT NULL,
    theme_tag        TEXT DEFAULT 'default',
    is_active        BOOLEAN DEFAULT TRUE,
    last_updated     TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ui_contract_address ON explorer_ui_metadata(contract_address);
