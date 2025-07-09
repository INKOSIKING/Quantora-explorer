-- ========================================
-- Schema: AI Intent Overlays
-- Purpose: Stores AI-detected behavioral intent signals from wallet actions
-- ========================================

CREATE TABLE IF NOT EXISTS ai_intent_overlays (
    overlay_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_address   VARCHAR(66) NOT NULL,
    intent_class     TEXT CHECK (intent_class IN (
        'liquidity_provision', 'market_manipulation', 'governance_vote', 
        'dapp_engagement', 'identity_pattern', 'zero_day_behavior'
    )),
    confidence_score NUMERIC CHECK (confidence_score BETWEEN 0 AND 1),
    ai_model_version TEXT NOT NULL,
    supporting_data  JSONB,
    created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_intent_wallet ON ai_intent_overlays(wallet_address);
CREATE INDEX IF NOT EXISTS idx_ai_intent_class ON ai_intent_overlays(intent_class);
