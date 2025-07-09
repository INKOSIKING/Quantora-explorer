-- Table: quantum_validation_attempts
-- Description: Tracks quantum algorithm or oracle-based validations attempted on-chain/off-chain.

CREATE TABLE IF NOT EXISTS quantum_validation_attempts (
    id BIGSERIAL PRIMARY KEY,
    validator_id UUID,
    block_number BIGINT NOT NULL,
    quantum_algorithm TEXT NOT NULL,
    challenge_input TEXT NOT NULL,
    result_output TEXT,
    passed BOOLEAN,
    error_message TEXT,
    cpu_time_ms INT,
    quantum_cycles_estimate BIGINT,
    attempted_at TIMESTAMPTZ DEFAULT now(),
    validated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_qv_validator ON quantum_validation_attempts(validator_id);
CREATE INDEX IF NOT EXISTS idx_qv_algorithm ON quantum_validation_attempts(quantum_algorithm);
CREATE INDEX IF NOT EXISTS idx_qv_result ON quantum_validation_attempts(passed);

COMMENT ON TABLE quantum_validation_attempts IS 'Logs all quantum-computing validation processes, useful for post-quantum cryptographic evaluation and quantum oracle research.';
