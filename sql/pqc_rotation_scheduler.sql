-- ─────────────────────────────────────────────────────────────────────────────
-- 🔐 PQC Key Rotation Scheduler & Historical Metadata
-- ─────────────────────────────────────────────────────────────────────────────

-- 🗝️ Table: pqc_key_registry
CREATE TABLE IF NOT EXISTS pqc_key_registry (
  key_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_id          TEXT NOT NULL,
  entity_type        TEXT CHECK (entity_type IN ('wallet', 'validator', 'peer', 'oracle')),
  algorithm          TEXT NOT NULL CHECK (algorithm IN ('Dilithium', 'Kyber', 'SPHINCS+', 'Falcon')),
  key_fingerprint    TEXT NOT NULL UNIQUE,
  issued_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at         TIMESTAMPTZ,
  rotated_from       UUID REFERENCES pqc_key_registry(key_id),
  rotation_reason    TEXT,
  active             BOOLEAN NOT NULL DEFAULT TRUE
);

-- 🔁 Table: pqc_rotation_schedule
CREATE TABLE IF NOT EXISTS pqc_rotation_schedule (
  schedule_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity_id          TEXT NOT NULL,
  next_rotation_at   TIMESTAMPTZ NOT NULL,
  rotation_interval_days INTEGER NOT NULL,
  urgency_level      TEXT CHECK (urgency_level IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
  enforced           BOOLEAN DEFAULT FALSE
);

-- 📊 Indexes
CREATE INDEX IF NOT EXISTS idx_pqc_entity ON pqc_key_registry(entity_id);
CREATE INDEX IF NOT EXISTS idx_pqc_schedule_entity ON pqc_rotation_schedule(entity_id);
CREATE INDEX IF NOT EXISTS idx_pqc_expiration ON pqc_key_registry(expires_at);
