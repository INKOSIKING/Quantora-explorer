-- ==========================================================================
-- Table: quantum_entropy_pools
-- Purpose: Secure pools of quantum-generated randomness for verifiable uses
-- ==========================================================================

CREATE TABLE IF NOT EXISTS quantum_entropy_pools (
  pool_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_device_id    VARCHAR(128) NOT NULL,
  entropy_blob        BYTEA NOT NULL,
  bits_generated      INTEGER NOT NULL CHECK (bits_generated > 0),
  sha256_fingerprint  VARCHAR(64) NOT NULL,
  is_exhausted        BOOLEAN DEFAULT FALSE,
  created_at          TIMESTAMPTZ DEFAULT NOW(),
  consumed_at         TIMESTAMPTZ,
  usage_type          VARCHAR(64), -- e.g., 'lottery', 'zk_proof', 'wallet_keygen'
  entropy_quality     NUMERIC CHECK (entropy_quality >= 0 AND entropy_quality <= 1)
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_qep_source_device_id ON quantum_entropy_pools(source_device_id);
CREATE INDEX IF NOT EXISTS idx_qep_usage_type       ON quantum_entropy_pools(usage_type);
CREATE INDEX IF NOT EXISTS idx_qep_created_quality  ON quantum_entropy_pools(created_at, entropy_quality);

-- === Constraints ===
ALTER TABLE quantum_entropy_pools
  ADD CONSTRAINT chk_fingerprint_format
    CHECK (sha256_fingerprint ~ '^[a-fA-F0-9]{64}$');
