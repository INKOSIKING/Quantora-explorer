-- =======================================================
-- 🪓 Table: deep_chain_reorgs
-- =======================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'deep_chain_reorgs'
  ) THEN
    CREATE TABLE deep_chain_reorgs (
      reorg_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      original_chain_tip    TEXT NOT NULL,
      new_chain_tip         TEXT NOT NULL,
      depth                 INT NOT NULL,
      affected_blocks       INT,
      trigger_event         TEXT,
      duration_ms           INT,
      data_loss_risk        BOOLEAN DEFAULT FALSE,
      mitigation_actions    TEXT,
      reorg_type            TEXT CHECK (reorg_type IN ('uncle_replacement', 'deep_reorg', 'fork_resolution', 'manual_override')),
      detected_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      resolved_at           TIMESTAMPTZ,
      notes                 TEXT
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_deep_reorg_original_tip ON deep_chain_reorgs(original_chain_tip);
CREATE INDEX IF NOT EXISTS idx_deep_reorg_new_tip ON deep_chain_reorgs(new_chain_tip);
