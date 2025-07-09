-- ===================================================================================
-- Table: dapp_analytics_sessions
-- Purpose: Captures behavioral, UX, and performance analytics for dApp usage sessions
-- ===================================================================================

CREATE TABLE IF NOT EXISTS dapp_analytics_sessions (
  session_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dapp_id            UUID NOT NULL,
  user_wallet        VARCHAR(66),
  user_agent         TEXT,
  device_type        TEXT,
  os_platform        TEXT,
  browser_name       TEXT,
  ip_address         INET,
  session_start      TIMESTAMPTZ DEFAULT NOW(),
  session_end        TIMESTAMPTZ,
  actions_count      INTEGER DEFAULT 0,
  error_count        INTEGER DEFAULT 0,
  was_successful     BOOLEAN DEFAULT TRUE,
  referrer_url       TEXT,
  country_code       CHAR(2),
  city_name          TEXT,
  network_latency_ms INTEGER,
  chain_id           TEXT,
  created_at         TIMESTAMPTZ DEFAULT NOW(),
  updated_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_das_dapp_id ON dapp_analytics_sessions(dapp_id);
CREATE INDEX IF NOT EXISTS idx_das_wallet ON dapp_analytics_sessions(user_wallet);
CREATE INDEX IF NOT EXISTS idx_das_geo ON dapp_analytics_sessions(country_code, city_name);
CREATE INDEX IF NOT EXISTS idx_das_start_end ON dapp_analytics_sessions(session_start, session_end);

-- === Trigger for updated_at ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_dapp_analytics_sessions_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_das_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trg_dapp_analytics_sessions_updated_at
    BEFORE UPDATE ON dapp_analytics_sessions
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_das_updated_at();
  END IF;
END
$$;
