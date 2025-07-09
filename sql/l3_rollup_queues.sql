-- ===================================================
-- Table: l3_rollup_queues
-- Purpose: Manages incoming, batched & pending L3 rollup data
-- Supports zk rollups, optimistic rollups & modular queueing
-- ===================================================

CREATE TABLE IF NOT EXISTS l3_rollup_queues (
  queue_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rollup_type         TEXT NOT NULL CHECK (rollup_type IN ('zk', 'optimistic', 'hybrid')),
  parent_chain_level  TEXT NOT NULL CHECK (parent_chain_level IN ('L1', 'L2')),
  batch_root          VARCHAR(66) NOT NULL,
  state_root_before   VARCHAR(66),
  state_root_after    VARCHAR(66),
  batch_data          BYTEA,
  proof_data          BYTEA,
  sequencer_id        UUID,
  status              TEXT NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending', 'verified', 'invalid', 'submitted')),
  inserted_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  verified_at         TIMESTAMPTZ,
  submitted_at        TIMESTAMPTZ,
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_l3rq_rollup_type     ON l3_rollup_queues(rollup_type);
CREATE INDEX IF NOT EXISTS idx_l3rq_batch_root      ON l3_rollup_queues(batch_root);
CREATE INDEX IF NOT EXISTS idx_l3rq_status          ON l3_rollup_queues(status);
CREATE INDEX IF NOT EXISTS idx_l3rq_inserted_at     ON l3_rollup_queues(inserted_at DESC);

-- === Trigger Function for updated_at ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_proc WHERE proname = 'fn_update_l3rq_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_l3rq_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
  END IF;
END
$$;

-- === Trigger Assignment ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_l3rq_updated_at'
  ) THEN
    CREATE TRIGGER trg_l3rq_updated_at
    BEFORE UPDATE ON l3_rollup_queues
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_l3rq_updated_at();
  END IF;
END
$$;
