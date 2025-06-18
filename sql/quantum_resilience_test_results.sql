-- 🧪 QUANTUM_RESILIENCE_TEST_RESULTS — PQ safety & sim audit results

CREATE TABLE IF NOT EXISTS quantum_resilience_test_results (
  test_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  test_target         TEXT NOT NULL, -- e.g. wallet, validator, protocol
  pq_algorithm_used   TEXT NOT NULL, -- e.g. Kyber1024, SPHINCS+, BLAKE3
  test_vector         TEXT NOT NULL,
  result_status       TEXT CHECK (result_status IN ('PASS','FAIL','WARN')),
  notes               TEXT,
  tested_at           TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_qr_test_target ON quantum_resilience_test_results(test_target);
