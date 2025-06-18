-- 🧲 QUANTUM_FORGERY_TRAP — Simulated Forgery Detection Layer

CREATE TABLE IF NOT EXISTS quantum_forgery_trap (
  trap_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  forged_tx_hash     VARCHAR(66) NOT NULL,
  fake_private_key   TEXT NOT NULL,
  quantum_vector     TEXT,
  forged_signature   TEXT,
  detected_at        TIMESTAMPTZ DEFAULT NOW(),
  ip_trace           INET,
  severity_rating    INTEGER CHECK (severity_rating BETWEEN 0 AND 10)
);

CREATE INDEX IF NOT EXISTS idx_forgery_tx ON quantum_forgery_trap(forged_tx_hash);
