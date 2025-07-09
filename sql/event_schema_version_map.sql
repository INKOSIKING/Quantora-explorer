-- ================================================
-- 🧩 Table: event_schema_version_map
-- ================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'event_schema_version_map'
  ) THEN
    CREATE TABLE event_schema_version_map (
      map_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      event_type       TEXT NOT NULL,
      indexer_name     TEXT NOT NULL,
      schema_version   TEXT NOT NULL,
      applied_hash     TEXT,
      recorded_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      notes            TEXT
    );
  END IF;
END;
$$;

