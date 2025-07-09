-- ============================================================================
-- File: validator_defense_stack.sql
-- Purpose: Resilience against validator misbehavior and denial vectors
-- ============================================================================

-- 1. Predictive Slashing Table
CREATE TABLE IF NOT EXISTS predictive_slashing (
    slashing_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    validator_address VARCHAR(66) NOT NULL,
    threat_score      NUMERIC CHECK (threat_score BETWEEN 0 AND 1),
    forecast_window   INTERVAL NOT NULL,
    triggered_action  TEXT CHECK (triggered_action IN ('none', 'warn', 'slash', 'quarantine')),
    source_model      TEXT NOT NULL,
    confidence        NUMERIC CHECK (confidence BETWEEN 0 AND 1),
    created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_slashing_validator ON predictive_slashing(validator_address);

-- 2. Gossip Denial Guard Table
CREATE TABLE IF NOT EXISTS gossip_denial_guard (
    incident_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    peer_id           UUID NOT NULL,
    affected_topic    TEXT NOT NULL,
    suppression_type  TEXT CHECK (suppression_type IN ('drop', 'delay', 'deform', 'mute')),
    evidence_blob     BYTEA,
    detection_tool    TEXT,
    severity_level    TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')),
    detected_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_gossip_incident_peer ON gossip_denial_guard(peer_id);

-- 3. Adaptive Fee Rewiring Table
CREATE TABLE IF NOT EXISTS adaptive_fee_rewiring (
    rewiring_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_hash           VARCHAR(66),
    original_fee_dest VARCHAR(66) NOT NULL,
    new_fee_dest      VARCHAR(66),
    reason_code       TEXT CHECK (reason_code IN (
                            'congestion_relief', 'validator_penalty', 'reorg_refund',
                            'flash_guard', 'spam_control')),
    auto_applied      BOOLEAN DEFAULT TRUE,
    applied_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fee_rewire_tx ON adaptive_fee_rewiring(tx_hash);
