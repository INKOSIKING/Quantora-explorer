-- ===================================================================================
-- Table: quantum_key_rotation_logs
-- Purpose: Track all cryptographic key rotations (esp. PQC-safe) for users/contracts
-- ===================================================================================

CREATE TABLE IF NOT EXISTS quantum_key_rotation_logs (
  rotation_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_type      VARCHAR(32) NOT NULL CHECK (subject_type IN ('wallet', 'contract', 'validator')),
  subject_identifier VARCHAR(128) NOT NULL, -- e.g., wallet_address, contract_address
  old_public_key    TEXT NOT NULL,
  new_public_key    TEXT NOT NULL,
  rotation_method   VARCHAR(64) NOT NULL CHECK (rotation_method IN (
                        'manual', 'threshold', 'quantum_safe', 'time_based', 'AI_initiated'
                      )),
  initiated_by      VARCHAR(66),
  rotation_reason   TEXT,
  approved_by_ai    BOOLEAN DEFAULT FALSE,
  rotated_at        TIMESTAMPTZ DEFAULT NOW(),
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_qkr_subject ON quantum_key_rotation_logs(subject_identifier);
CREATE INDEX IF NOT EXISTS idx_qkr_method  ON quantum_key_rotation_logs(rotation_method);
CREATE INDEX IF NOT EXISTS idx_qkr_ai_flag ON quantum_key_rotation_logs(approved_by_ai);

-- === Constraints ===
ALTER TABLE quantum_key_rotation_logs
  ADD CONSTRAINT chk_subject_format
    CHECK (subject_identifier ~ '^0x[a-fA-F0-9]{40}$');
