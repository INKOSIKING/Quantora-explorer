-- 🔍 CONTRACT_LOGIC_FUZZ_AUDITS — Smart contract bug hunting results

CREATE TABLE IF NOT EXISTS contract_logic_fuzz_audits (
  audit_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address    VARCHAR(66) NOT NULL,
  tool_name           TEXT NOT NULL,  -- e.g. Echidna, MythX, Slither
  issue_type          TEXT NOT NULL,
  severity_level      TEXT CHECK (severity_level IN ('LOW','MEDIUM','HIGH','CRITICAL')),
  fuzz_seed_hash      TEXT,
  discovered_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fuzz_contract ON contract_logic_fuzz_audits(contract_address);
CREATE INDEX IF NOT EXISTS idx_fuzz_severity ON contract_logic_fuzz_audits(severity_level);
