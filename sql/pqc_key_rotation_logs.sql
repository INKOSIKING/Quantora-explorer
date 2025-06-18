-- 🔄 PQC_KEY_ROTATION_LOGS — Post-quantum key lifecycle logging

CREATE TABLE IF NOT EXISTS pqc_key_rotation_logs (
  rotation_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_address     VARCHAR(66) NOT NULL,
  key_type           TEXT NOT NULL CHECK (key_type IN ('Dilithium', 'Kyber', 'SPHINCS+', 'Falcon')),
  previous_key_hash  TEXT,
  new_key_hash       TEXT NOT NULL,
  rotated_by         TEXT NOT NULL,
  compliance_check   BOOLEAN DEFAULT FALSE,
  rotation_timestamp TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pqc_wallet ON pqc_key_rotation_logs(wallet_address);
