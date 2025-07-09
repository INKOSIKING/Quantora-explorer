-- ============================================================================
-- Table: blockchain_liveness_metrics
-- Purpose: Tracks protocol liveness, fork stalls, validator uptime, deadlocks
-- ============================================================================

CREATE TABLE IF NOT EXISTS blockchain_liveness_metrics (
    metric_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    block_height         BIGINT NOT NULL,
    fork_id              TEXT,
    active_validators    INT,
    missed_slots         INT,
    deadlock_detected    BOOLEAN DEFAULT FALSE,
    churn_rate           NUMERIC, -- % of validators that left/entered
    gossip_latency_ms    INTEGER,
    heartbeat_gap_sec    INTEGER,
    fork_stall_seconds   INTEGER,
    slot_sync_variance   NUMERIC,
    reported_at          TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_liveness_block_height ON blockchain_liveness_metrics(block_height);
CREATE INDEX IF NOT EXISTS idx_liveness_fork ON blockchain_liveness_metrics(fork_id);
