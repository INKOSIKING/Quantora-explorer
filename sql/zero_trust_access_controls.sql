-- ─────────────────────────────────────────────────────────────────────────────
-- 🔐 ZERO TRUST ACCESS CONTROLS — PQ-safe decentralized security
-- ─────────────────────────────────────────────────────────────────────────────

-- 🧩 Table: zero_trust_identities
CREATE TABLE IF NOT EXISTS zero_trust_identities (
  identity_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  public_key_pqc      TEXT NOT NULL,  -- CRYSTALS-Dilithium, Kyber, etc.
  identity_type       TEXT NOT NULL CHECK (identity_type IN ('validator', 'operator', 'agent', 'observer')),
  zone                TEXT NOT NULL,
  metadata            JSONB,
  registered_at       TIMESTAMPTZ DEFAULT NOW()
);

-- 🔑 Table: zero_trust_sessions
CREATE TABLE IF NOT EXISTS zero_trust_sessions (
  session_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  identity_id         UUID NOT NULL REFERENCES zero_trust_identities(identity_id),
  session_start       TIMESTAMPTZ DEFAULT NOW(),
  session_expiry      TIMESTAMPTZ NOT NULL,
  allowed_actions     TEXT[] NOT NULL,
  session_signature   TEXT NOT NULL,
  granted_by          TEXT,
  session_metadata    JSONB
);

-- 🔍 Table: zero_trust_access_logs
CREATE TABLE IF NOT EXISTS zero_trust_access_logs (
  access_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id          UUID NOT NULL REFERENCES zero_trust_sessions(session_id),
  access_time         TIMESTAMPTZ DEFAULT NOW(),
  resource_requested  TEXT NOT NULL,
  access_outcome      TEXT NOT NULL CHECK (access_outcome IN ('allowed', 'denied', 'expired')),
  source_ip           INET,
  access_details      JSONB
);

CREATE INDEX IF NOT EXISTS idx_zero_trust_identity ON zero_trust_sessions(identity_id);
CREATE INDEX IF NOT EXISTS idx_access_logs_session ON zero_trust_access_logs(session_id);
