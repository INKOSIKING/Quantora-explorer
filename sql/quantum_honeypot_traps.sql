-- ============================================================
-- Schema: Quantum Honeypot Traps
-- Purpose: Detects and logs post-quantum attacks via honeypots
-- ============================================================

CREATE TABLE IF NOT EXISTS quantum_honeypot_traps (
    trap_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_address      VARCHAR(66) NOT NULL,
    pqc_scheme          TEXT NOT NULL,
    bait_signature      BYTEA,
    attempt_payload     BYTEA,
    trap_triggered_at   TIMESTAMPTZ DEFAULT NOW(),
    attacker_fingerprint TEXT,
    risk_rating         TEXT CHECK (risk_rating IN ('low', 'moderate', 'critical')) DEFAULT 'moderate'
);

CREATE INDEX IF NOT EXISTS idx_qhp_wallet ON quantum_honeypot_traps(wallet_address);
