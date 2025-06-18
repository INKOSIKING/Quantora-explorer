-- 🎲 QUANTUM_ENTROPY_ORACLES — True quantum randomness feeds

CREATE TABLE IF NOT EXISTS quantum_entropy_oracles (
  entropy_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source_name        TEXT NOT NULL,
  entropy_blob       BYTEA NOT NULL,
  entropy_bits       INTEGER CHECK (entropy_bits > 0),
  entropy_quality    NUMERIC(4,3) CHECK (entropy_quality BETWEEN 0 AND 1),
  collected_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_entropy_source ON quantum_entropy_oracles(source_name);
CREATE INDEX IF NOT EXISTS idx_entropy_quality ON quantum_entropy_oracles(entropy_quality);
