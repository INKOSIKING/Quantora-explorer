-- ============================================================================================
-- 🤖 Table: ai_audit_trails
-- Description: Tracks AI decisions, prompts, model metadata and user interaction history for transparency & security.
-- ============================================================================================

CREATE TABLE IF NOT EXISTS ai_audit_trails (
    audit_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ai_context_id         TEXT NOT NULL, -- correlation ID for session or request context
    model_name            TEXT NOT NULL, -- e.g. 'gpt-4', 'custom-ml-v2'
    input_prompt          TEXT NOT NULL,
    ai_response           TEXT,
    temperature           NUMERIC(3,2) DEFAULT 1.00,
    top_p                 NUMERIC(3,2) DEFAULT 1.00,
    user_id               TEXT,
    related_contract      TEXT,
    is_flagged            BOOLEAN DEFAULT FALSE,
    flagged_reason        TEXT,
    latency_ms            INTEGER,
    status_code           INTEGER,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_audit_context_id ON ai_audit_trails(ai_context_id);
CREATE INDEX IF NOT EXISTS idx_ai_audit_user_id ON ai_audit_trails(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_audit_flagged ON ai_audit_trails(is_flagged);
CREATE INDEX IF NOT EXISTS idx_ai_audit_created_at ON ai_audit_trails(created_at DESC);
