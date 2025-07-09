-- =============================================
-- 🧊 Table: light_client_snapshots
-- =============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'light_client_snapshots'
  ) THEN
    CREATE TABLE light_client_snapshots (
      snapshot_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      block_number        BIGINT NOT NULL,
      block_hash          TEXT NOT NULL,
      state_root          TEXT NOT NULL,
      finalized           BOOLEAN NOT NULL DEFAULT FALSE,
      validator_set_hash  TEXT,
      proof_blob          BYTEA,
      created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_light_snapshots_block_hash ON light_client_snapshots(block_hash);
CREATE INDEX IF NOT EXISTS idx_light_snapshots_block_number ON light_client_snapshots(block_number);
