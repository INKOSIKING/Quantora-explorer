-- ======================================================================
-- Table: gossip_health_metrics
-- Purpose: Real-time validator gossip propagation health and telemetry
-- ======================================================================

CREATE TABLE IF NOT EXISTS gossip_health_metrics (
    record_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    validator_id        VARCHAR(66) NOT NULL,
    peer_count          INT NOT NULL CHECK (peer_count >= 0),
    avg_latency_ms      NUMERIC(8, 3) NOT NULL CHECK (avg_latency_ms >= 0),
    gossip_coverage_pct NUMERIC(5, 2) CHECK (gossip_coverage_pct BETWEEN 0 AND 100),
    missed_blocks       INT DEFAULT 0 CHECK (missed_blocks >= 0),
    duplicate_msgs      INT DEFAULT 0 CHECK (duplicate_msgs >= 0),
    invalid_msgs        INT DEFAULT 0 CHECK (invalid_msgs >= 0),
    memory_pressure_pct NUMERIC(5, 2) CHECK (memory_pressure_pct BETWEEN 0 AND 100),
    epoch               BIGINT NOT NULL,
    recorded_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes for efficient analytics ===
CREATE INDEX IF NOT EXISTS idx_gossip_health_epoch ON gossip_health_metrics(epoch);
CREATE INDEX IF NOT EXISTS idx_gossip_validator ON gossip_health_metrics(validator_id);
