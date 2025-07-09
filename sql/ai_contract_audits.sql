-- ==========================================================================
-- 🤖 Table: ai_contract_audits
-- Description: Stores automated smart contract audit results generated
-- by AI/ML systems. Includes classification, vulnerabilities, risk levels.
-- ==========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_contract_audits'
  ) THEN
    CREATE TABLE ai_contract_audits (
      audit_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address   TEXT NOT NULL,
      audit_engine       TEXT NOT NULL, -- e.g., "QuantoraAI", "GPT-Audit"
      engine_version     TEXT,
      audit_timestamp    TIMESTAMPTZ DEFAULT NOW(),
      risk_score         NUMERIC(5,2) CHECK (risk_score >= 0 AND risk_score <= 100),
      issues_detected    INTEGER DEFAULT 0,
      issues             JSONB,         -- Structured list of findings
      severity_summary   JSONB,         -- {critical: 1, high: 2, ...}
      recommended_fixes  JSONB,
      report_hash        TEXT,          -- Hash of full report (stored off-chain)
      report_url         TEXT,          -- Optional IPFS/URL reference
      inserted_at        TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_audit_contract ON ai_contract_audits(contract_address);
CREATE INDEX IF NOT EXISTS idx_ai_audit_score ON ai_contract_audits(risk_score);
