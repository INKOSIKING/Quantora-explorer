-- 🔐 PQC_KEY_ROTATION_EVENTS — Secure key evolution logs

CREATE TABLE IF NOT EXISTS pqc_key_rotation_events (
  rotation_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_type        TEXT NOT NULL,  -- wallet, validator, contract, system
  subject_id          TEXT NOT NULL,
  old_key_hash        TEXT NOT NULL,
  new_key_hash        TEXT NOT NULL,
  pqc_scheme          TEXT NOT NULL, -- e.g. Dilithium3, Kyber1024
  rotated_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_key_rotation_subject ON pqc_key_rotation_events(subject_id);
