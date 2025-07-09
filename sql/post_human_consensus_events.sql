-- ============================================================
-- Schema: Post-Human Consensus Events
-- Purpose: Logs contributions from AGI, synthetic or hybrid nodes
-- ============================================================

CREATE TABLE IF NOT EXISTS post_human_consensus_events (
    event_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    node_identifier     TEXT NOT NULL,
    entity_type         TEXT CHECK (entity_type IN ('human', 'AI', 'cybernetic', 'unknown')) NOT NULL,
    consensus_vote      TEXT,
    trust_score         NUMERIC CHECK (trust_score >= 0 AND trust_score <= 1),
    cognitive_weighting NUMERIC,
    event_payload       JSONB,
    recorded_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_phc_node ON post_human_consensus_events(node_identifier);
