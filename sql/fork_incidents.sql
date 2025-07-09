-- =====================================================
-- 🌪️ Table: fork_incidents
-- =====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'fork_incidents'
  ) THEN
    CREATE TABLE fork_incidents (
      fork_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      competing_chain_id  TEXT NOT NULL,
      base_block_number   BIGINT NOT NULL,
      base_block_hash     TEXT NOT NULL,
      fork_block_number   BIGINT NOT NULL,
      fork_block_hash     TEXT NOT NULL,
      detected_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      resolution_status   TEXT DEFAULT 'unresolved', -- e.g. resolved, ignored, in_review
      resolution_summary  TEXT,
      resolved_at         TIMESTAMPTZ,
      notes               TEXT
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_fork_base_number ON fork_incidents(base_block_number);
CREATE INDEX IF NOT EXISTS idx_fork_fork_number ON fork_incidents(fork_block_number);
