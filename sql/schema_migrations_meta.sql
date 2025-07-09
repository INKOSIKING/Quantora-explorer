-- ============================================================
-- 🧬 Table: schema_migrations_meta
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'schema_migrations_meta'
  ) THEN
    CREATE TABLE schema_migrations_meta (
      migration_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      version           TEXT NOT NULL,
      description       TEXT,
      applied_by        TEXT,
      applied_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      checksum          TEXT NOT NULL,
      execution_time_ms INT,
      status            TEXT NOT NULL DEFAULT 'success', -- success, failed
      rollback_sql      TEXT,
      source_file       TEXT
    );
  END IF;
END;
$$;

