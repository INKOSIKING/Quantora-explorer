-- ===================================================================================================
-- 🤖 Table: ai_oracle_interactions
-- Description: Logs every interaction between smart contracts or backend processes and AI-based oracles.
-- Used for transparency, auditability, and reproducibility of off-chain AI-driven insights.
-- ===================================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_oracle_interactions'
  ) THEN
    CREATE TABLE ai_oracle_interactions (
      interaction_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_name           TEXT NOT NULL,           -- e.g., 'gpt-4o', 'quantora-vlm', etc.
      model_version        TEXT,
      prompt_hash          TEXT NOT NULL,
      response_hash        TEXT NOT NULL,
      purpose              TEXT,                    -- e.g., 'risk_assessment', 'oracle_price_feed'
      data_reference       TEXT,                    -- Optional external dataset/URL
      contract_address     TEXT,
      tx_hash              TEXT,
      block_number         BIGINT,
      executed_by_address  TEXT,
      latency_ms           INTEGER,
      confidence_score     NUMERIC(5,2),
      was_cached           BOOLEAN DEFAULT FALSE,
      inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_model_usage ON ai_oracle_interactions(model_name, model_version);
CREATE INDEX IF NOT EXISTS idx_ai_tx_hash ON ai_oracle_interactions(tx_hash);
CREATE INDEX IF NOT EXISTS idx_ai_contract ON ai_oracle_interactions(contract_address);
CREATE INDEX IF NOT EXISTS idx_ai_inserted_at ON ai_oracle_interactions(inserted_at);

