-- 🔏 ZK_PROOF_BATCH_VERIFIER — Bulk ZK proof validation logs

CREATE TABLE IF NOT EXISTS zk_proof_batch_verifier (
  batch_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  prover_identity   TEXT NOT NULL,
  proof_type        TEXT NOT NULL CHECK (proof_type IN ('zkSNARK', 'zkSTARK', 'PLONK', 'Halo2')),
  num_proofs        INTEGER NOT NULL CHECK (num_proofs >= 1),
  verification_time_ms BIGINT,
  was_valid         BOOLEAN DEFAULT FALSE,
  protocol_version  TEXT,
  verified_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_zk_proof_prover ON zk_proof_batch_verifier(prover_identity);
CREATE INDEX IF NOT EXISTS idx_zk_proof_type ON zk_proof_batch_verifier(proof_type);
