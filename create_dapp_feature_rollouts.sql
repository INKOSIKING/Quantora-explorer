-- ============================================================================================
-- 🚀 Table: dapp_feature_rollouts
-- Description: Tracks feature toggles, rollout phases, and user segmentation for DApp features.
-- ============================================================================================

CREATE TABLE IF NOT EXISTS dapp_feature_rollouts (
    rollout_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feature_name          TEXT NOT NULL,
    dapp_name             TEXT NOT NULL,
    version_tag           TEXT,
    is_enabled            BOOLEAN DEFAULT FALSE,
    rollout_strategy      TEXT CHECK (rollout_strategy IN ('full', 'percentage', 'region_based', 'wallet_based')),
    rollout_value         TEXT, -- % or list of conditions
    start_time            TIMESTAMPTZ,
    end_time              TIMESTAMPTZ,
    created_by            TEXT,
    last_modified_by      TEXT,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_feature_name ON dapp_feature_rollouts(feature_name);
CREATE INDEX IF NOT EXISTS idx_dapp_rollout_strategy ON dapp_feature_rollouts(rollout_strategy);
CREATE INDEX IF NOT EXISTS idx_dapp_is_enabled ON dapp_feature_rollouts(is_enabled);
CREATE INDEX IF NOT EXISTS idx_dapp_created_at ON dapp_feature_rollouts(created_at DESC);
