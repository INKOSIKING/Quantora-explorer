-- ====================================================
-- 🤖 Table: ai_usage_quotas
-- Description: Tracks AI access consumption per user, 
-- project, and time frame. Useful for rate-limiting,
-- billing, auditing and governance.
-- ====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_usage_quotas'
  ) THEN
    CREATE TABLE ai_usage_quotas (
      quota_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id            TEXT NOT NULL,
      api_key_hash       TEXT,
      model_name         TEXT NOT NULL,
      usage_tokens       BIGINT NOT NULL DEFAULT 0,
      quota_limit        BIGINT NOT NULL,
      reset_interval     INTERVAL NOT NULL DEFAULT INTERVAL '1 day',
      period_start       TIMESTAMPTZ NOT NULL,
      period_end         TIMESTAMPTZ NOT NULL,
      enforced           BOOLEAN NOT NULL DEFAULT TRUE,
      notes              TEXT,
      updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_quota_user ON ai_usage_quotas(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_quota_period ON ai_usage_quotas(period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_ai_quota_model ON ai_usage_quotas(model_name);
