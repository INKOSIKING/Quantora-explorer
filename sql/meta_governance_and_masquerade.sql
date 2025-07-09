-- ─────────────────────────────────────────────────────────────────────────────
-- 🗳 META_GOVERNANCE_OUTCOME_TRACKER — Links on-chain proposals to outcomes
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_governance_outcome_tracker (
    outcome_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposal_id       UUID NOT NULL,
    enacted           BOOLEAN DEFAULT FALSE,
    outcome_summary   TEXT,
    block_height      BIGINT,
    voter_distribution JSONB,
    sentiment_shift   TEXT,
    decided_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_governance_proposal ON meta_governance_outcome_tracker(proposal_id);
CREATE INDEX IF NOT EXISTS idx_governance_enacted ON meta_governance_outcome_tracker(enacted);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🕵️ META_VALIDATOR_MASQUERADE_DETECTOR — Detects identity spoofing across clusters
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_validator_masquerade_detector (
    alert_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    suspected_node_id TEXT NOT NULL,
    ip_fingerprint    TEXT,
    signature_overlap TEXT,
    masquerade_score  NUMERIC(4,3) CHECK (masquerade_score >= 0.000 AND masquerade_score <= 1.000),
    evidence_blob     BYTEA,
    reported_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_validator_node ON meta_validator_masquerade_detector(suspected_node_id);
CREATE INDEX IF NOT EXISTS idx_validator_score ON meta_validator_masquerade_detector(masquerade_score);
