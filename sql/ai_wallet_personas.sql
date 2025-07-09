-- ==============================================================================
-- Table: ai_wallet_personas
-- Purpose: Represent AI-controlled wallet profiles and their behavioral patterns
-- Use case: Autonomous trading, DAOs, predictive agents, simulation bots
-- ==============================================================================

CREATE TABLE IF NOT EXISTS ai_wallet_personas (
  persona_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_address     VARCHAR(66) NOT NULL UNIQUE,
  model_architecture TEXT NOT NULL,               -- e.g., GPT-4, RLHF-BERT, CustomNet
  objective_profile  TEXT,                        -- JSON: { strategy: "arbitrage", risk_tolerance: "low", ... }
  current_state      JSONB DEFAULT '{}'::jsonb,   -- runtime state, e.g., portfolio snapshot
  ai_version         VARCHAR(64),                 -- version of AI controlling wallet
  autonomy_level     INT CHECK (autonomy_level BETWEEN 0 AND 10), -- 0 = passive, 10 = fully autonomous
  last_decision_at   TIMESTAMPTZ,
  active             BOOLEAN DEFAULT TRUE,
  created_at         TIMESTAMPTZ DEFAULT NOW(),
  updated_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_ai_wallet_personas_wallet ON ai_wallet_personas(wallet_address);
CREATE INDEX IF NOT EXISTS idx_ai_wallet_personas_active ON ai_wallet_personas(active);
CREATE INDEX IF NOT EXISTS idx_ai_wallet_personas_ai_version ON ai_wallet_personas(ai_version);

-- === Triggers ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_ai_wallet_personas_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_ai_wallet_personas_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trg_ai_wallet_personas_updated_at
    BEFORE UPDATE ON ai_wallet_personas
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_ai_wallet_personas_updated_at();
  END IF;
END
$$;

-- === Constraints ===
ALTER TABLE ai_wallet_personas
  ADD CONSTRAINT chk_wallet_address_format
    CHECK (wallet_address ~ '^0x[a-fA-F0-9]{40}$');
