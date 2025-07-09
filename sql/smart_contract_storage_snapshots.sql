-- ==================================================================
-- 🧠 Table: smart_contract_storage_snapshots
-- ==================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'smart_contract_storage_snapshots'
  ) THEN
    CREATE TABLE smart_contract_storage_snapshots (
      snapshot_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address  TEXT NOT NULL,
      storage_root      TEXT NOT NULL,
      storage_json      JSONB NOT NULL,
      snapshot_hash     TEXT NOT NULL,
      taken_at_block    BIGINT NOT NULL,
      taken_at_time     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      version           INTEGER NOT NULL DEFAULT 1,
      snapshot_source   TEXT CHECK (snapshot_source IN ('manual', 'automated', 'rollup_node')),
      notes             TEXT
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_snapshots_contract_address ON smart_contract_storage_snapshots(contract_address);
CREATE INDEX IF NOT EXISTS idx_snapshots_taken_at_block ON smart_contract_storage_snapshots(taken_at_block);
