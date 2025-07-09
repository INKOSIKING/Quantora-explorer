-- ============================================================
-- Schema: L5 Temporal Causality Bridges
-- Purpose: Anchors cross-time-layer state convergence and integrity
-- ============================================================

CREATE TABLE IF NOT EXISTS l5_temporal_causality_bridges (
    bridge_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_temporal_layer   TEXT NOT NULL,
    target_temporal_layer   TEXT NOT NULL,
    anchor_state_hash       VARCHAR(66) NOT NULL,
    causality_proof_blob    BYTEA,
    causal_confidence       NUMERIC CHECK (causal_confidence >= 0 AND causal_confidence <= 1),
    anomaly_flagged         BOOLEAN DEFAULT FALSE,
    created_at              TIMESTAMPTZ DEFAULT NOW(),
    verified_at             TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_tcb_source_target ON l5_temporal_causality_bridges(source_temporal_layer, target_temporal_layer);
