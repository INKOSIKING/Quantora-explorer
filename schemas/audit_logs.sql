-- File: schemas/audit_logs.sql

CREATE TABLE IF NOT EXISTS audit_logs (
  audit_id        BIGSERIAL PRIMARY KEY,
  actor           VARCHAR(66), -- Address or system component
  action_type     TEXT NOT NULL, -- e.g., INSERT, UPDATE, DELETE, SYSTEM_EVENT
  target_table    TEXT NOT NULL,
  target_id       TEXT,
  old_value       JSONB,
  new_value       JSONB,
  context         TEXT, -- optional description or request id
  ip_address      INET,
  user_agent      TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_audit_logs_table ON audit_logs (target_table);
CREATE INDEX IF NOT EXISTS idx_audit_logs_actor ON audit_logs (actor);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs (action_type);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created ON audit_logs (created_at DESC);

-- 🔒 Optional constraints
ALTER TABLE audit_logs
  ADD CONSTRAINT chk_actor_format CHECK (actor IS NULL OR actor ~ '^0x[a-fA-F0-9]{40}$');
