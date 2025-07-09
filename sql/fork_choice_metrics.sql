-- ===========================================
-- 🧭 Table: fork_choice_metrics
-- ===========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'fork_choice_metrics'
  ) THEN
    CREATE TABLE fork_choice_metrics (
      metric_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      timestamp          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      block_number       BIGINT NOT NULL,
      current_head       TEXT NOT NULL,
      parent_head        TEXT,
      competing_heads    JSONB,
      head_switch_count  INT DEFAULT 0,
      longest_chain_len  INT,
      fork_depth         INT,
      cause              TEXT,
      resolved           BOOLEAN DEFAULT FALSE
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_fork_choice_block_number ON fork_choice_metrics(block_number);
CREATE INDEX IF NOT EXISTS idx_fork_choice_timestamp ON fork_choice_metrics(timestamp);
