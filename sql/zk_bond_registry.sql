-- ======================================================================
-- Table: zk_bond_registry
-- Purpose: Tracks staked zk-bonds, slashing, and validator proof integrity
-- ======================================================================

CREATE TABLE IF NOT EXISTS zk_bond_registry (
    bond_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    validator_address  VARCHAR(66) NOT NULL,
    bond_amount        NUMERIC(78, 0) NOT NULL CHECK (bond_amount > 0),
    zk_proof_hash      VARCHAR(66),
    proof_epoch        BIGINT NOT NULL,
    status             TEXT NOT NULL CHECK (status IN ('active', 'slashed', 'withdrawn')),
    slashed_at         TIMESTAMPTZ,
    staked_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_zk_bond_validator ON zk_bond_registry(validator_address);
CREATE INDEX IF NOT EXISTS idx_zk_bond_epoch ON zk_bond_registry(proof_epoch);

-- === Constraints ===
ALTER TABLE zk_bond_registry
  ADD CONSTRAINT chk_zk_bond_hash_format
    CHECK (zk_proof_hash IS NULL OR zk_proof_hash ~ '^0x[a-fA-F0-9]{64}$')
  NOT VALID;
