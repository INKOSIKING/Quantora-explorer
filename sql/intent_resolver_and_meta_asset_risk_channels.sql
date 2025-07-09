-- ─────────────────────────────────────────────────────────────────────────────
-- �� INTENT_RESOLVER_OVERLAYS — Semantic layer for user intent modeling
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS intent_resolver_overlays (
    intent_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_address    VARCHAR(66) NOT NULL,
    intent_type       TEXT NOT NULL,
    intent_payload    JSONB NOT NULL,
    resolution_path   TEXT,
    resolved_at       TIMESTAMPTZ,
    status            TEXT CHECK (status IN ('pending', 'resolved', 'failed')) DEFAULT 'pending',
    created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_intent_wallet ON intent_resolver_overlays(wallet_address);
CREATE INDEX IF NOT EXISTS idx_intent_type_status ON intent_resolver_overlays(intent_type, status);

-- ─────────────────────────────────────────────────────────────────────────────
-- 📉 META_ASSET_RISK_CHANNELS — Risk propagation and monitoring by asset or token type
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_asset_risk_channels (
    channel_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asset_symbol      TEXT NOT NULL,
    risk_score        NUMERIC(6,3) NOT NULL,
    propagation_vector JSONB,
    anomaly_flag      BOOLEAN DEFAULT FALSE,
    detected_at       TIMESTAMPTZ DEFAULT NOW(),
    updated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_risk_asset_symbol ON meta_asset_risk_channels(asset_symbol);
