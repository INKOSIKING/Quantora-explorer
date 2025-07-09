-- ============================================================
-- Schema: AI Guardian Nodes
-- Purpose: Intelligent agents monitoring and optimizing consensus
-- ============================================================

CREATE TABLE IF NOT EXISTS ai_guardian_nodes (
    node_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_name         TEXT NOT NULL,
    model_version      TEXT NOT NULL,
    model_hash         VARCHAR(66) NOT NULL,
    decision_scope     TEXT CHECK (decision_scope IN ('consensus', 'governance', 'security', 'optimization')) NOT NULL,
    performance_rating NUMERIC CHECK (performance_rating >= 0 AND performance_rating <= 100),
    status             TEXT CHECK (status IN ('active', 'hibernating', 'disabled')) DEFAULT 'active',
    last_sync_time     TIMESTAMPTZ DEFAULT NOW(),
    updated_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_guardians_scope ON ai_guardian_nodes(decision_scope);
CREATE INDEX IF NOT EXISTS idx_ai_guardians_status ON ai_guardian_nodes(status);
