-- ===================================================================
-- Schema: Post-Human Consensus Observations
-- Purpose: Logs synthetic + emergent consensus events from AI observers
-- ===================================================================

CREATE TABLE IF NOT EXISTS post_human_consensus_observations (
    observation_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    observer_model     TEXT NOT NULL,
    consensus_snapshot BYTEA NOT NULL,
    interpretation     TEXT,
    anomaly_score      NUMERIC CHECK (anomaly_score >= 0 AND anomaly_score <= 1),
    trust_weight       NUMERIC DEFAULT 1.0,
    observed_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_phc_observer_model ON post_human_consensus_observations(observer_model);
CREATE INDEX IF NOT EXISTS idx_phc_anomaly_score ON post_human_consensus_observations(anomaly_score);
CREATE INDEX IF NOT EXISTS idx_phc_trust_weight ON post_human_consensus_observations(trust_weight);
