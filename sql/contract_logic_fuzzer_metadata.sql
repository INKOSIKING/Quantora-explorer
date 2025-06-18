-- ─────────────────────────────────────────────────────────────────────────────
-- �� Smart Contract Fuzzing & Logic Mutation Tracker
-- ─────────────────────────────────────────────────────────────────────────────

-- 🔧 Table: contract_fuzzing_runs
CREATE TABLE IF NOT EXISTS contract_fuzzing_runs (
  run_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address TEXT NOT NULL,
  source_hash      TEXT NOT NULL,
  fuzz_round       INTEGER NOT NULL,
  mutation_type    TEXT NOT NULL,
  fuzz_engine      TEXT NOT NULL,
  result_summary   TEXT,
  crash_detected   BOOLEAN DEFAULT false,
  run_time_ms      BIGINT,
  fuzzed_at        TIMESTAMPTZ DEFAULT NOW()
);

-- 📊 Table: fuzz_gas_anomalies
CREATE TABLE IF NOT EXISTS fuzz_gas_anomalies (
  anomaly_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address TEXT NOT NULL,
  fuzz_round       INTEGER NOT NULL,
  baseline_gas     BIGINT NOT NULL,
  observed_gas     BIGINT NOT NULL,
  deviation_pct    NUMERIC(5,2),
  flagged_at       TIMESTAMPTZ DEFAULT NOW()
);

-- 🧬 Table: fuzzy_logic_alerts
CREATE TABLE IF NOT EXISTS fuzzy_logic_alerts (
  alert_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address TEXT NOT NULL,
  alert_level      TEXT CHECK (alert_level IN ('info', 'warning', 'critical')),
  message          TEXT NOT NULL,
  triggered_by     TEXT,
  triggered_at     TIMESTAMPTZ DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_fuzzing_contract ON contract_fuzzing_runs(contract_address);
CREATE INDEX IF NOT EXISTS idx_gas_anomalies_contract ON fuzz_gas_anomalies(contract_address);
CREATE INDEX IF NOT EXISTS idx_fuzzy_alerts_level ON fuzzy_logic_alerts(alert_level);
