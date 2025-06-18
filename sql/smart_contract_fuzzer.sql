-- ─────────────────────────────────────────────────────────────────────────────
-- 🧪 SMART CONTRACT FUZZER — Mutation-based exploit discovery
-- ─────────────────────────────────────────────────────────────────────────────

-- 🔬 Table: fuzz_test_campaigns
CREATE TABLE IF NOT EXISTS fuzz_test_campaigns (
  campaign_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address  VARCHAR(66) NOT NULL,
  entry_function    TEXT NOT NULL,
  mutation_depth    INTEGER NOT NULL,
  strategy          TEXT CHECK (strategy IN ('random', 'guided', 'grammar-based')),
  campaign_notes    TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- 🧫 Table: fuzz_inputs
CREATE TABLE IF NOT EXISTS fuzz_inputs (
  input_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id       UUID NOT NULL REFERENCES fuzz_test_campaigns(campaign_id),
  mutated_input     JSONB NOT NULL,
  input_seed        TEXT,
  gas_used          BIGINT,
  observed_behavior TEXT,
  crash_signature   TEXT,
  vulnerability_type TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- 📈 Table: fuzz_coverage
CREATE TABLE IF NOT EXISTS fuzz_coverage (
  coverage_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  campaign_id       UUID NOT NULL REFERENCES fuzz_test_campaigns(campaign_id),
  function_tested   TEXT NOT NULL,
  instruction_hit   INTEGER NOT NULL,
  instruction_total INTEGER NOT NULL,
  gas_cost_avg      BIGINT,
  coverage_percent  NUMERIC(5,2),
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fuzz_contract ON fuzz_test_campaigns(contract_address);
CREATE INDEX IF NOT EXISTS idx_fuzz_campaign_input ON fuzz_inputs(campaign_id);
CREATE INDEX IF NOT EXISTS idx_coverage_campaign ON fuzz_coverage(campaign_id);
