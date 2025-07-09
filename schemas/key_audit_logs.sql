-- File: schemas/key_audit_logs.sql

CREATE TABLE IF NOT EXISTS key_audit_logs (
  audit_id         BIGSERIAL PRIMARY KEY,
  key_id           VARCHAR(128) NOT NULL,
  action           TEXT NOT NULL, -- e.g., "generated", "rotated", "revoked"
  performed_by     TEXT NOT NULL,
  ip_address       INET,
  timestamp        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  details          JSONB
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_key_audit_logs_key_id ON key_audit_logs (key_id);
CREATE INDEX IF NOT EXISTS idx_key_audit_logs_action ON key_audit_logs (action);
CREATE INDEX IF NOT EXISTS idx_key_audit_logs_timestamp ON key_audit_logs (timestamp DESC);
