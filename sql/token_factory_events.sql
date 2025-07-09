-- ====================================================
-- 🪙 Table: token_factory_events
-- Description: Logs token creation, modification,
--              upgrade and deprecation actions
-- ====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'token_factory_events'
  ) THEN
    CREATE TABLE token_factory_events (
      event_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      token_address      TEXT NOT NULL,
      token_symbol       TEXT NOT NULL,
      token_name         TEXT NOT NULL,
      action             TEXT NOT NULL CHECK (action IN ('created', 'updated', 'burned', 'minted', 'frozen', 'revoked')),
      initiated_by       TEXT NOT NULL,
      supply_change      NUMERIC,
      metadata           JSONB,
      event_tx_hash      TEXT,
      block_number       BIGINT,
      chain_context      TEXT,
      occurred_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_token_event_address ON token_factory_events(token_address);
CREATE INDEX IF NOT EXISTS idx_token_event_action ON token_factory_events(action);
CREATE INDEX IF NOT EXISTS idx_token_event_time ON token_factory_events(occurred_at);
