-- ============================================================
-- Schema: Temporal Checkpoint Beacons
-- Purpose: Anchors cross-shard, cross-time consensus finality
-- ============================================================

CREATE TABLE IF NOT EXISTS temporal_checkpoint_beacons (
    beacon_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chain_domain       TEXT NOT NULL,
    block_height       BIGINT NOT NULL,
    timestamp_anchor   TIMESTAMPTZ NOT NULL,
    root_hash          VARCHAR(66) NOT NULL,
    entropy_vector     BYTEA,
    causality_vector   BYTEA,
    validator_signature BYTEA,
    time_accuracy_score NUMERIC CHECK (time_accuracy_score >= 0 AND time_accuracy_score <= 1),
    confirmed          BOOLEAN DEFAULT FALSE,
    created_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_temporal_beacons_chain_height ON temporal_checkpoint_beacons(chain_domain, block_height);
CREATE INDEX IF NOT EXISTS idx_temporal_beacons_time ON temporal_checkpoint_beacons(timestamp_anchor);
