-- ─────────────────────────────────────────────────────────────────────────────
-- 🧬 META_SCHEMA_LOG — Track every schema evolution step (like Git for schemas)
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_schema_log (
    revision_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    applied_by       TEXT NOT NULL,
    change_type      TEXT CHECK (change_type IN ('CREATE', 'ALTER', 'DROP', 'COMMENT', 'RENAME')) NOT NULL,
    object_type      TEXT CHECK (object_type IN ('TABLE', 'VIEW', 'INDEX', 'FUNCTION', 'TRIGGER')) NOT NULL,
    object_name      TEXT NOT NULL,
    ddl_statement    TEXT NOT NULL,
    applied_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_meta_schema_obj ON meta_schema_log(object_name);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🤖 AI_INTENT_LOG — Log AI system behavior, intentions, interpretations
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ai_intent_log (
    intent_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_name       TEXT NOT NULL,
    intent_type      TEXT NOT NULL,
    target_entity    TEXT,
    target_action    TEXT,
    context_json     JSONB,
    outcome_status   TEXT CHECK (outcome_status IN ('success', 'error', 'timeout', 'noop')) DEFAULT 'noop',
    created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_intent_agent ON ai_intent_log(agent_name);
CREATE INDEX IF NOT EXISTS idx_ai_intent_type ON ai_intent_log(intent_type);
