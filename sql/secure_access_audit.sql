-- 📊 Table: secure_access_audit
CREATE TABLE IF NOT EXISTS secure_access_audit (
  audit_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_wallet    TEXT NOT NULL,
  accessed_module TEXT NOT NULL,
  access_type     TEXT CHECK (access_type IN ('read', 'write', 'admin')),
  device_fingerprint TEXT,
  origin_ip       INET,
  geo_location    TEXT,
  threat_score    NUMERIC(3,1) DEFAULT 0.0 CHECK (threat_score BETWEEN 0.0 AND 10.0),
  access_time     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_audit_actor ON secure_access_audit(actor_wallet);
CREATE INDEX IF NOT EXISTS idx_audit_time ON secure_access_audit(access_time);
