-- ===============================================================================================
-- 📊 Table: smart_contract_function_metrics
-- Description: Tracks granular usage and AI-derived insights on smart contract function calls.
-- Supports gas efficiency, error rate, call frequency, and behavioral modeling.
-- ===============================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'smart_contract_function_metrics'
  ) THEN
    CREATE TABLE smart_contract_function_metrics (
      metric_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address       TEXT NOT NULL,
      function_signature     TEXT NOT NULL, -- e.g. transfer(address,uint256)
      call_count             BIGINT DEFAULT 0,
      avg_gas_used           BIGINT,
      failure_rate           NUMERIC(5,2) CHECK (failure_rate BETWEEN 0 AND 100),
      ai_usage_label         TEXT, -- e.g. "frequent", "abused", "rare", etc.
      last_called_at         TIMESTAMPTZ,
      anomaly_score          NUMERIC(5,2),
      recommended_optimizations TEXT,
      notes                  TEXT,
      evaluated_at           TIMESTAMPTZ DEFAULT NOW(),
      extra_metadata         JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_contract_function ON smart_contract_function_metrics(contract_address, function_signature);
CREATE INDEX IF NOT EXISTS idx_function_call_count ON smart_contract_function_metrics(call_count);
CREATE INDEX IF NOT EXISTS idx_anomaly_score ON smart_contract_function_metrics(anomaly_score);

