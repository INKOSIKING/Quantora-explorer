-- 🧪 CONTRACT_FUZZING_LOGS — Fuzz Test Results & Failure Mapping

CREATE TABLE IF NOT EXISTS contract_fuzzing_logs (
  fuzz_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address   VARCHAR(66) NOT NULL,
  input_vector       TEXT NOT NULL,
  trigger_exception  TEXT,
  crash_signature    TEXT,
  reproducible       BOOLEAN DEFAULT FALSE,
  fuzzer_tool        TEXT,
  run_timestamp      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fuzz_contract ON contract_fuzzing_logs(contract_address);
