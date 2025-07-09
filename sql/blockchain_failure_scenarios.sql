-- ====================================================================================================
-- ⚠️ Table: blockchain_failure_scenarios
-- Description: Tracks rare or hypothetical failure conditions for postmortem and proactive mitigation.
-- Useful for monitoring reorgs, slashing conditions, oracle inconsistencies, consensus drift, etc.
-- ====================================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'blockchain_failure_scenarios'
  ) THEN
    CREATE TABLE blockchain_failure_scenarios (
      scenario_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      scenario_type         TEXT NOT NULL,              -- e.g., 'double_sign', 'oracle_mismatch', 'state_inconsistency'
      trigger_condition     TEXT NOT NULL,
      affected_component    TEXT,                       -- e.g., 'consensus_engine', 'bridge_adapter'
      severity_level        TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')),
      occurred_at           TIMESTAMPTZ NOT NULL,
      resolved_at           TIMESTAMPTZ,
      resolution_notes      TEXT,
      was_reorg_related     BOOLEAN DEFAULT FALSE,
      affected_block_hash   TEXT,
      inserted_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_failure_type ON blockchain_failure_scenarios(scenario_type);
CREATE INDEX IF NOT EXISTS idx_failure_severity ON blockchain_failure_scenarios(severity_level);
CREATE INDEX IF NOT EXISTS idx_failure_occurred_at ON blockchain_failure_scenarios(occurred_at);
CREATE INDEX IF NOT EXISTS idx_failure_block_hash ON blockchain_failure_scenarios(affected_block_hash);

