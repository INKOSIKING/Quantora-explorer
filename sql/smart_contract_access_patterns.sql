-- ============================================================
-- 📊 Table: smart_contract_access_patterns
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'smart_contract_access_patterns'
  ) THEN
    CREATE TABLE smart_contract_access_patterns (
      pattern_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address      TEXT NOT NULL,
      caller_address        TEXT NOT NULL,
      access_type           TEXT NOT NULL CHECK (access_type IN ('read', 'write', 'execute')),
      access_count          BIGINT NOT NULL DEFAULT 1,
      average_gas_used      BIGINT,
      peak_gas_usage        BIGINT,
      most_recent_access    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      method_signature      TEXT,
      notes                 TEXT,
      created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

