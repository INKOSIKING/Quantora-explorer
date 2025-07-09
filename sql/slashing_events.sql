-- =====================================================
-- ⚔️ Table: slashing_events
-- =====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'slashing_events'
  ) THEN
    CREATE TABLE slashing_events (
      event_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      validator_address  TEXT NOT NULL,
      reason_code        TEXT NOT NULL,
      penalty_type       TEXT CHECK (penalty_type IN ('minor', 'severe', 'permanent')) NOT NULL,
      block_number       BIGINT NOT NULL,
      slashed_amount     NUMERIC(30, 8),
      evidence_hash      TEXT,
      detected_at        TIMESTAMPTZ NOT NULL,
      processed_by       TEXT,
      inserted_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_slashing_validator ON slashing_events(validator_address);
CREATE INDEX IF NOT EXISTS idx_slashing_block ON slashing_events(block_number);
