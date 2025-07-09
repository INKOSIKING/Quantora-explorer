-- ======================================================
-- Table: quantum_keys
-- Purpose: Post-quantum cryptographic account support
-- ======================================================

CREATE TABLE IF NOT EXISTS quantum_keys (
    key_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_address  VARCHAR(66) NOT NULL,
    pqc_algorithm   TEXT NOT NULL,
    public_key      BYTEA NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (wallet_address, pqc_algorithm)
);
