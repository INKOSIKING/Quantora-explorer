-- ===================================================================================
-- Table: autonomous_agent_logs
-- Purpose: Logs all activity, decisions, and events from dApps, AI bots, and agents
-- ===================================================================================

CREATE TABLE IF NOT EXISTS autonomous_agent_logs (
  log_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id            TEXT NOT NULL,
  agent_type          TEXT CHECK (agent_type IN ('oracle', 'trading_bot', 'monitor', 'governance', 'security', 'custom')),
  activity_type       TEXT CHECK (activity_type IN ('decision', 'alert', 'trade', 'vote', 'mutation', 'observation', 'other')),
  action_payload      JSONB NOT NULL,
  result_summary      TEXT,
  was_successful      BOOLEAN DEFAULT TRUE,
  related_tx_hash     VARCHAR(66),
  related_contract    VARCHAR(66),
  gas_spent           BIGINT,
  execution_time_ms   INT,
  created_at          TIMESTAMPTZ DEFAULT NOW(),
  updated_at          TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_agent_logs_agent_id ON autonomous_agent_logs(agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_logs_type ON autonomous_agent_logs(agent_type);
CREATE INDEX IF NOT EXISTS idx_agent_logs_tx_hash ON autonomous_agent_logs(related_tx_hash);

-- === Trigger for updated_at ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_autonomous_agent_logs_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_autonomous_agent_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trg_autonomous_agent_logs_updated_at
    BEFORE UPDATE ON autonomous_agent_logs
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_autonomous_agent_updated_at();
  END IF;
END
$$;
