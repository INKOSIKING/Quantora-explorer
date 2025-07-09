-- ─────────────────────────────────────────────────────────────────────────────
-- �� META_SMART_AGENT_REFLECTOR — Mirrors and predicts autonomous agent behavior
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_smart_agent_reflector (
    agent_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_address   VARCHAR(66) NOT NULL,
    observed_behavior  TEXT,
    intent_pattern     TEXT,
    predicted_action   TEXT,
    agent_vector       BYTEA,
    reflected_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_reflector_contract ON meta_smart_agent_reflector(contract_address);
CREATE INDEX IF NOT EXISTS idx_reflector_intent ON meta_smart_agent_reflector(intent_pattern);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🌐 META_SOCIAL_CONSENSUS_MEMORY — Records off-chain social agreement states
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_social_consensus_memory (
    memory_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposal_topic   TEXT NOT NULL,
    decision_summary TEXT,
    signal_origin    TEXT CHECK (signal_origin IN ('twitter', 'forum', 'governance-ai', 'chat')),
    support_ratio    NUMERIC(5,4) CHECK (support_ratio BETWEEN 0.0000 AND 1.0000),
    recorded_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_social_topic ON meta_social_consensus_memory(proposal_topic);
CREATE INDEX IF NOT EXISTS idx_social_origin ON meta_social_consensus_memory(signal_origin);
