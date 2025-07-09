-- ============================================================================
-- Table: l3_fraud_watchdog
-- Purpose: Detects, logs, and flags fraud events across L3 rollups
-- ============================================================================

CREATE TABLE IF NOT EXISTS l3_fraud_watchdog (
    watchdog_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    l3_domain_id        TEXT NOT NULL,
    rollup_batch_id     TEXT NOT NULL,
    tx_hash             VARCHAR(66),
    anomaly_type        TEXT CHECK (anomaly_type IN (
                            'invalid_state_transition',
                            'zk_proof_mismatch',
                            'timestamp_forgery',
                            'replay_attack',
                            'unauthorized_actor'
                          )) NOT NULL,
    severity_level      TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
    detected_by         TEXT NOT NULL,
    zk_snapshot_hash    VARCHAR(66),
    proof_blob          BYTEA,
    remediation_status  TEXT CHECK (remediation_status IN ('pending', 'escalated', 'resolved')) DEFAULT 'pending',
    detected_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_l3_fraud_rollup ON l3_fraud_watchdog(rollup_batch_id);
CREATE INDEX IF NOT EXISTS idx_l3_fraud_domain ON l3_fraud_watchdog(l3_domain_id);
