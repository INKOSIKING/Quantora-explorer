-- =============================================
-- ⌛ Table: blockchain_state_aging
-- =============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'blockchain_state_aging'
  ) THEN
    CREATE TABLE blockchain_state_aging (
      aging_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      snapshot_block_number  BIGINT NOT NULL,
      snapshot_hash          TEXT NOT NULL,
      state_root             TEXT NOT NULL,
      total_accounts         BIGINT NOT NULL,
      stale_accounts         BIGINT NOT NULL,
      active_contracts       BIGINT NOT NULL,
      dormant_contracts      BIGINT NOT NULL,
      state_db_size_mb       NUMERIC(10,2),
      archived               BOOLEAN DEFAULT FALSE,
      analysis_timestamp     TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

