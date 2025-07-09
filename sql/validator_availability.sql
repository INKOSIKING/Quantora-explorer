-- ============================================
-- 📶 Table: validator_availability
-- ============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'validator_availability'
  ) THEN
    CREATE TABLE validator_availability (
      availability_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      validator_id        TEXT NOT NULL,
      status              TEXT CHECK (status IN ('online', 'offline', 'degraded')) NOT NULL,
      first_observed_at   TIMESTAMPTZ NOT NULL,
      last_observed_at    TIMESTAMPTZ,
      total_downtime_sec  BIGINT DEFAULT 0,
      reliability_score   NUMERIC(5,2),
      recent_error_logs   TEXT[],
      updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

CREATE INDEX IF NOT EXISTS idx_validator_status ON validator_availability(validator_id, status);
