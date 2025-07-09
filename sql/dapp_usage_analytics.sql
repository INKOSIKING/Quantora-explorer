-- ==========================================================================================
-- 📊 Table: dapp_usage_analytics
-- Description: Tracks on-chain usage patterns, sessions, and transaction stats for DApps.
-- Supports advanced behavioral tracking for dashboards and ecosystem insights.
-- ==========================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'dapp_usage_analytics'
  ) THEN
    CREATE TABLE dapp_usage_analytics (
      usage_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      dapp_name            TEXT NOT NULL,
      contract_address     TEXT NOT NULL,
      user_address         TEXT NOT NULL,
      session_id           UUID,
      interaction_type     TEXT, -- e.g. 'read', 'write', 'mint', 'swap'
      tx_hash              TEXT,
      block_number         BIGINT,
      chain_id             TEXT,
      method_invoked       TEXT,
      gas_used             BIGINT,
      value_transferred    NUMERIC(78, 0),
      event_signature      TEXT,
      device_metadata      JSONB,
      client_app_version   TEXT,
      user_country         TEXT,
      user_agent_hash      TEXT,
      first_seen_at        TIMESTAMPTZ,
      last_seen_at         TIMESTAMPTZ,
      inserted_at          TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_contract_user ON dapp_usage_analytics(dapp_name, contract_address, user_address);
CREATE INDEX IF NOT EXISTS idx_dapp_session ON dapp_usage_analytics(session_id);
CREATE INDEX IF NOT EXISTS idx_dapp_tx ON dapp_usage_analytics(tx_hash);
CREATE INDEX IF NOT EXISTS idx_dapp_country ON dapp_usage_analytics(user_country);

