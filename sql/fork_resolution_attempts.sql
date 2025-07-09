-- ==========================================================
-- 🌿 Table: fork_resolution_attempts
-- ==========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'fork_resolution_attempts'
  ) THEN
    CREATE TABLE fork_resolution_attempts (
      fork_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      conflicting_block   TEXT NOT NULL,
      preferred_block     TEXT NOT NULL,
      fork_height         BIGINT NOT NULL,
      resolution_method   TEXT NOT NULL, -- e.g., 'longest-chain', 'heaviest', 'finality-based'
      success             BOOLEAN NOT NULL DEFAULT TRUE,
      reason              TEXT,
      detected_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      resolved_at         TIMESTAMPTZ,
      validator_snapshot  JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_fork_conflict ON fork_resolution_attempts(conflicting_block);
CREATE INDEX IF NOT EXISTS idx_fork_height ON fork_resolution_attempts(fork_height);
CREATE INDEX IF NOT EXISTS idx_fork_resolved_at ON fork_resolution_attempts(resolved_at);
