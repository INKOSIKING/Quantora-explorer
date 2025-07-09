-- ================================================
-- 🔐 Table: schema_checksum_snapshots
-- ================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'schema_checksum_snapshots'
  ) THEN
    CREATE TABLE schema_checksum_snapshots (
      snapshot_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      snapshot_name      TEXT NOT NULL,
      schema_hash        TEXT NOT NULL,
      generated_by       TEXT NOT NULL,
      source_host        TEXT,
      pg_version         TEXT,
      full_schema_dump   TEXT,
      taken_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      notes              TEXT,
      validated          BOOLEAN DEFAULT TRUE,
      validation_method  TEXT,
      diff_against       UUID REFERENCES schema_checksum_snapshots(snapshot_id)
    );
  END IF;
END;
$$;

