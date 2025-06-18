-- ─────────────────────────────────────────────────────────────────────────────
-- 🔐 QUANTUM_KEY_ROTATION — PQC Key Lifecycle Tracking
-- ─────────────────────────────────────────────────────────────────────────────

-- 🔑 Table: quantum_keys
CREATE TABLE IF NOT EXISTS quantum_keys (
  key_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_address     TEXT NOT NULL,
  key_type          TEXT NOT NULL CHECK (key_type IN ('dilithium', 'kyber', 'sphincs+', 'falcon')),
  public_key        TEXT NOT NULL,
  valid_from        TIMESTAMPTZ NOT NULL,
  valid_until       TIMESTAMPTZ,
  revoked           BOOLEAN DEFAULT FALSE,
  revoked_reason    TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- 🔁 Table: key_rotation_events
CREATE TABLE IF NOT EXISTS key_rotation_events (
  rotation_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_address     TEXT NOT NULL,
  old_key_id        UUID NOT NULL REFERENCES quantum_keys(key_id),
  new_key_id        UUID NOT NULL REFERENCES quantum_keys(key_id),
  reason            TEXT,
  rotated_by        TEXT NOT NULL,
  rotated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_qk_owner ON quantum_keys(owner_address);
CREATE INDEX IF NOT EXISTS idx_rotation_owner ON key_rotation_events(owner_address);
