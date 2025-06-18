-- 🛡️ ZERO_TRUST_ACCESS_AUDIT_LOGS — Access trace under zero trust

CREATE TABLE IF NOT EXISTS zero_trust_access_audit_logs (
  access_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id            TEXT NOT NULL,
  actor_type          TEXT NOT NULL, -- user, node, daemon, tool
  resource_accessed   TEXT NOT NULL,
  access_granted      BOOLEAN NOT NULL,
  reason              TEXT,
  access_time         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_zta_actor ON zero_trust_access_audit_logs(actor_id);
CREATE INDEX IF NOT EXISTS idx_zta_resource ON zero_trust_access_audit_logs(resource_accessed);
