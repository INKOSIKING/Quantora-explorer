-- 🧪 CONTRACT_LOGIC_FUZZER_LOGS — Stores fuzzer traces, crashes & mutant inputs

CREATE TABLE IF NOT EXISTS contract_logic_fuzzer_logs (
  fuzz_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address    VARCHAR(66) NOT NULL,
  fuzzer_engine       TEXT,
  mutated_input       JSONB,
  crash_detected      BOOLEAN DEFAULT FALSE,
  crash_trace         TEXT,
  gas_used            BIGINT,
  block_height        BIGINT,
  fuzzed_at           TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fuzzer_contract ON contract_logic_fuzzer_logs(contract_address);
