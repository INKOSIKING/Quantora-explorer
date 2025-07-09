-- ==========================================================================
-- 💰 Table: token_supply_snapshots
-- Description: Tracks total, circulating, and burned supply snapshots
-- of all tokens over time. Useful for tokenomics analysis and auditing.
-- ==========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'token_supply_snapshots'
  ) THEN
    CREATE TABLE token_supply_snapshots (
      snapshot_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      token_address      TEXT NOT NULL,
      block_number       BIGINT NOT NULL,
      block_hash         TEXT,
      snapshot_time      TIMESTAMPTZ DEFAULT NOW(),
      total_supply       NUMERIC(78, 0) NOT NULL,
      circulating_supply NUMERIC(78, 0),
      burned_supply      NUMERIC(78, 0),
      mint_events        INTEGER DEFAULT 0,
      burn_events        INTEGER DEFAULT 0,
      notes              TEXT,
      inserted_at        TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_token_snapshot_token_block ON token_supply_snapshots(token_address, block_number);
CREATE INDEX IF NOT EXISTS idx_token_snapshot_time ON token_supply_snapshots(snapshot_time);
