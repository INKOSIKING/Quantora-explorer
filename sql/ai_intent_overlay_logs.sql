-- ============================================================
-- Schema: AI Intent Overlay Logs
-- Purpose: Tracks AI-generated transaction intents and traces
-- ============================================================

CREATE TABLE IF NOT EXISTS ai_intent_overlay_logs (
    intent_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    originating_address VARCHAR(66) NOT NULL,
    inferred_action     TEXT NOT NULL,
    confidence_score    NUMERIC CHECK (confidence_score >= 0 AND confidence_score <= 1),
    overlay_data        JSONB,
    model_version       TEXT,
    interpretability_map BYTEA,
    generated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_intents_address ON ai_intent_overlay_logs(originating_address);
