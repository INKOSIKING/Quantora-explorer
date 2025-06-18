-- 🔐 ZERO_TRUST_SESSIONS — Identity-aware session integrity tracking

CREATE TABLE IF NOT EXISTS zero_trust_sessions (
  session_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id            UUID NOT NULL,
  device_id          TEXT NOT NULL,
  location_coords    POINT,
  access_token_hash  TEXT NOT NULL,
  integrity_score    NUMERIC(3,2) CHECK (integrity_score BETWEEN 0.00 AND 1.00),
  challenge_passed   BOOLEAN DEFAULT FALSE,
  session_started_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_zts_user_device ON zero_trust_sessions(user_id, device_id);
