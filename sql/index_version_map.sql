-- ========================================
-- 🗺️ Table: index_version_map
-- ========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'index_version_map'
  ) THEN
    CREATE TABLE index_version_map (
      map_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      index_module     TEXT NOT NULL,
      schema_version   TEXT NOT NULL,
      code_version     TEXT NOT NULL,
      checksum         TEXT NOT NULL,
      migration_id     TEXT,
      compatible       BOOLEAN DEFAULT TRUE,
      deployed_by      TEXT,
      deployed_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      notes            TEXT
    );
  END IF;
END;
$$;

