-- ===========================================
-- 🚨 Table: attestation_failures
-- ===========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'attestation_failures'
  ) THEN
    CREATE TABLE attestation_failures (
      failure_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      validator_id       TEXT NOT NULL,
      epoch_number       BIGINT NOT NULL,
      slot_number        BIGINT,
      reason             TEXT,
      penalty_imposed    BOOLEAN DEFAULT FALSE,
      penalty_amount     NUMERIC(20, 8),
      network_conditions JSONB,
      observed_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_attestation_validator_epoch ON attestation_failures(validator_id, epoch_number);
