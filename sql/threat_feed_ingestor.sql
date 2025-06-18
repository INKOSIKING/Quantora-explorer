-- ─────────────────────────────────────────────────────────────────────────────
-- 🌐 EXTERNAL THREAT FEED INGESTION — CVE, Darknet, Advisory Watchers
-- ─────────────────────────────────────────────────────────────────────────────

-- 🧠 Table: threat_feeds
CREATE TABLE IF NOT EXISTS threat_feeds (
  feed_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source             TEXT NOT NULL,
  fetched_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  feed_type          TEXT CHECK (feed_type IN ('RSS', 'API', 'Manual', 'CVE', 'GitHub')),
  url                TEXT,
  raw_payload        JSONB NOT NULL
);

-- 🛡️ Table: threat_alerts
CREATE TABLE IF NOT EXISTS threat_alerts (
  alert_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title              TEXT NOT NULL,
  severity           TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')) NOT NULL,
  source             TEXT NOT NULL,
  cve_id             TEXT,
  published_at       TIMESTAMPTZ,
  affected_systems   TEXT[],
  vulnerability_type TEXT,
  payload_ref        UUID REFERENCES threat_feeds(feed_id),
  auto_flagged       BOOLEAN DEFAULT FALSE,
  created_at         TIMESTAMPTZ DEFAULT NOW()
);

-- 🧮 Indexes
CREATE INDEX IF NOT EXISTS idx_threat_cve ON threat_alerts(cve_id);
CREATE INDEX IF NOT EXISTS idx_threat_severity ON threat_alerts(severity);
CREATE INDEX IF NOT EXISTS idx_threat_source ON threat_feeds(source);
