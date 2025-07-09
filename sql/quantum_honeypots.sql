-- ========================================
-- Schema: Quantum Honeypots
-- Purpose: Decoys for detecting post-quantum exploit attempts
-- ========================================

CREATE TABLE IF NOT EXISTS quantum_honeypots (
    honeypot_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trap_address    VARCHAR(66) NOT NULL UNIQUE,
    pqc_algorithm   TEXT NOT NULL,
    decoy_key       BYTEA NOT NULL,
    trigger_count   INTEGER DEFAULT 0,
    last_triggered  TIMESTAMPTZ,
    threat_level    TEXT CHECK (threat_level IN ('low', 'medium', 'high', 'critical')) DEFAULT 'low',
    detection_notes JSONB,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_qhoneypots_triggered ON quantum_honeypots(last_triggered);
CREATE INDEX IF NOT EXISTS idx_qhoneypots_threat_level ON quantum_honeypots(threat_level);
