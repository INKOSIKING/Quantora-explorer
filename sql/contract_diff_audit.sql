-- ============================================================
-- 🧾 Table: contract_diff_audit
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'contract_diff_audit'
  ) THEN
    CREATE TABLE contract_diff_audit (
      diff_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address  TEXT NOT NULL,
      network_id        TEXT NOT NULL,
      diff_timestamp    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      previous_code     TEXT,
      current_code      TEXT,
      code_diff_summary TEXT,
      change_type       TEXT CHECK (change_type IN ('added', 'modified', 'deleted', 'renamed', 'optimized')),
      diff_tool_used    TEXT,
      reviewer          TEXT,
      verified_change   BOOLEAN DEFAULT FALSE,
      review_notes      TEXT
    );
  END IF;
END;
$$;

