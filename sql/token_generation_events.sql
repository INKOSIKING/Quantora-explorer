-- ========================================================
-- 🪙 Table: token_generation_events
-- Description: Tracks every token creation on-chain,
-- including metadata, contract, creator, and AI flags.
-- ========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'token_generation_events'
  ) THEN
    CREATE TABLE token_generation_events (
      event_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      token_address        TEXT NOT NULL,
      token_symbol         TEXT NOT NULL,
      token_name           TEXT NOT NULL,
      total_supply         NUMERIC(38, 0),
      creator_address      TEXT NOT NULL,
      creator_contract     TEXT,
      creation_tx_hash     TEXT NOT NULL,
      creation_block       BIGINT NOT NULL,
      ai_generated         BOOLEAN DEFAULT FALSE,
      metadata_uri         TEXT,
      created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_token_creator ON token_generation_events(creator_address);
CREATE INDEX IF NOT EXISTS idx_token_contract ON token_generation_events(token_address);
CREATE INDEX IF NOT EXISTS idx_token_block ON token_generation_events(creation_block);
