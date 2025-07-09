-- ==========================================================================
-- Table: zk_execution_logs
-- Purpose: Logs zero-knowledge proof executions, outcomes, runtimes,
-- purposes, and proof metadata used in Quantora blockchain.
-- ==========================================================================

CREATE TABLE IF NOT EXISTS zk_execution_logs (
  zk_exec_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proof_id          UUID NOT NULL,
  proof_type        VARCHAR(64) NOT NULL CHECK (
                      proof_type IN (
                        'zkSNARK',
                        'zkSTARK',
                        'PLONK',
                        'Halo2',
                        'Groth16',
                        'Marlin'
                      )
                    ),
  circuit_name      VARCHAR(128),
  executed_by       VARCHAR(128),
  execution_time_ms INTEGER CHECK (execution_time_ms >= 0),
  gas_cost_estimate BIGINT,
  block_height      BIGINT,
  context_scope     VARCHAR(64) CHECK (
                      context_scope IN (
                        'transaction_validation',
                        'identity_proof',
                        'data_commitment',
                        'oracle_validation',
                        'confidential_computation'
                      )
                    ),
  success           BOOLEAN NOT NULL DEFAULT TRUE,
  error_message     TEXT,
  proof_size_bytes  INTEGER,
  proof_hash        VARCHAR(128),
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_zk_exec_proof_type    ON zk_execution_logs(proof_type);
CREATE INDEX IF NOT EXISTS idx_zk_exec_context       ON zk_execution_logs(context_scope);
CREATE INDEX IF NOT EXISTS idx_zk_exec_block_height  ON zk_execution_logs(block_height);
CREATE INDEX IF NOT EXISTS idx_zk_exec_success       ON zk_execution_logs(success);

-- === Foreign Key to zkp_proofs ===
ALTER TABLE zk_execution_logs
  ADD CONSTRAINT fk_zk_proof_reference
    FOREIGN KEY (proof_id)
    REFERENCES zkp_proofs(proof_id) ON DELETE CASCADE;

