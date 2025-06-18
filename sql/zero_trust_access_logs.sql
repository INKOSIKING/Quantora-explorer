-- 🛡️ ZERO_TRUST_ACCESS_LOGS — Endpoint access, session-based auth & justification tracking

CREATE TABLE IF NOT EXISTS zero_trust_access_logs (
  access_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id            TEXT NOT NULL,
  resource_requested  TEXT NOT NULL,
  access_decision     TEXT NOT NULL CHECK (access_decision IN ('ALLOW', 'DENY')),
  justification       TEXT,
  session_id          UUID,
  ip_address          INET,
  user_agent          TEXT,
  accessed_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_zero_trust_actor ON zero_trust_access_logs(actor_id);
CREATE INDEX IF NOT EXISTS idx_zero_trust_session ON zero_trust_access_logs(session_id);
