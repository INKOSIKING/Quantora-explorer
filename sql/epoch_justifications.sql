-- ===========================================
-- 🧭 Table: epoch_justifications
-- ===========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'epoch_justifications'
  ) THEN
    CREATE TABLE epoch_justifications (
      justification_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      epoch_number        BIGINT NOT NULL,
      justified           BOOLEAN NOT NULL DEFAULT FALSE,
      justification_type  TEXT,
      justification_root  TEXT,
      finalized            BOOLEAN DEFAULT FALSE,
      finalization_root    TEXT,
      participating_votes INT,
      total_votes         INT,
      justification_ratio NUMERIC(5,2),
      noted_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_epoch_number ON epoch_justifications(epoch_number);
