-- =======================================================================================
-- 🧠 Table: onchain_feature_flags
-- Description: On-chain activated feature toggles for blockchain logic and DApps.
-- =======================================================================================

CREATE TABLE IF NOT EXISTS onchain_feature_flags (
    flag_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feature_key           TEXT NOT NULL UNIQUE,
    enabled               BOOLEAN NOT NULL DEFAULT FALSE,
    activation_block      BIGINT,
    deactivation_block    BIGINT,
    contract_address      TEXT,
    controlling_module    TEXT,
    governance_approved   BOOLEAN DEFAULT FALSE,
    notes                 TEXT,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_onchain_feature_key ON onchain_feature_flags(feature_key);
CREATE INDEX IF NOT EXISTS idx_onchain_enabled ON onchain_feature_flags(enabled);
CREATE INDEX IF NOT EXISTS idx_onchain_activation_block ON onchain_feature_flags(activation_block);
