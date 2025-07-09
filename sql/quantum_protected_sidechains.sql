-- ===========================================================
-- Schema: Quantum-Protected Sidechains
-- Purpose: High-security execution environments using PQ crypto
-- ===========================================================

CREATE TABLE IF NOT EXISTS quantum_sidechains (
    sidechain_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    chain_name         TEXT NOT NULL UNIQUE,
    pqc_algorithm      TEXT NOT NULL,
    pqc_genesis_key    BYTEA NOT NULL,
    genesis_block_hash VARCHAR(66) NOT NULL,
    validator_count    INT NOT NULL,
    current_height     BIGINT DEFAULT 0,
    status             TEXT CHECK (status IN ('active', 'paused', 'retired')) DEFAULT 'active',
    created_at         TIMESTAMPTZ DEFAULT NOW(),
    updated_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_qsidechains_status ON quantum_sidechains(status);
CREATE INDEX IF NOT EXISTS idx_qsidechains_name ON quantum_sidechains(chain_name);
