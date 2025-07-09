-- =============================================================================
-- Table: zk_inference_logs
-- Purpose: Verifiable AI inference results using zero-knowledge proofs
-- =============================================================================

CREATE TABLE IF NOT EXISTS zk_inference_logs (
  inference_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_hash           VARCHAR(66) NOT NULL, -- Hash of model used
  input_commitment     VARCHAR(66) NOT NULL, -- Commitment to input vector
  output_hash          VARCHAR(66) NOT NULL, -- Hash of model output
  proof_blob           BYTEA NOT NULL,       -- ZK proof
  verifier_contract    VARCHAR(66),          -- Optional on-chain verifier
  inference_type       VARCHAR(64),          -- e.g., fraud-detection, price-forecast
  verified             BOOLEAN DEFAULT FALSE,
  verification_ts      TIMESTAMPTZ,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  metadata             JSONB
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_zk_inference_model ON zk_inference_logs(model_hash);
CREATE INDEX IF NOT EXISTS idx_zk_inference_type  ON zk_inference_logs(inference_type);
CREATE INDEX IF NOT EXISTS idx_zk_verified_flag   ON zk_inference_logs(verified);

-- === Constraints ===
ALTER TABLE zk_inference_logs
  ADD CONSTRAINT chk_model_hash_format
    CHECK (model_hash ~ '^0x[a-fA-F0-9]{64}$');

ALTER TABLE zk_inference_logs
  ADD CONSTRAINT chk_output_hash_format
    CHECK (output_hash ~ '^0x[a-fA-F0-9]{64}$');

ALTER TABLE zk_inference_logs
  ADD CONSTRAINT chk_input_commitment_format
    CHECK (input_commitment ~ '^0x[a-fA-F0-9]{64}$');
