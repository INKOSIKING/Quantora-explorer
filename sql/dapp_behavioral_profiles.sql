-- ====================================================================================
-- Table: dapp_behavioral_profiles
-- Purpose: Logs behavioral analytics, anomaly detections, and ML-derived traits
-- ====================================================================================

CREATE TABLE IF NOT EXISTS dapp_behavioral_profiles (
  profile_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address   VARCHAR(66) NOT NULL,
  chain_id           TEXT NOT NULL,
  request_rate       NUMERIC,                 -- Requests per time unit
  avg_gas_usage      NUMERIC,
  tx_pattern         TEXT,                    -- JSON pattern or regex of usage
  flags              TEXT[],                  -- ['spammy', 'volatile', 'flashloan-heavy']
  threat_score       NUMERIC CHECK (threat_score BETWEEN 0 AND 100),
  ai_profile         JSONB,                   -- { intent: 'DeFi lending', risk: 'low', ... }
  last_active_at     TIMESTAMPTZ,
  updated_at         TIMESTAMPTZ DEFAULT NOW(),
  created_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE UNIQUE INDEX IF NOT EXISTS uq_dapp_profile_addr_chain
  ON dapp_behavioral_profiles(contract_address, chain_id);

CREATE INDEX IF NOT EXISTS idx_dapp_threat_score
  ON dapp_behavioral_profiles(threat_score DESC);

-- === Constraints ===
ALTER TABLE dapp_behavioral_profiles
  ADD CONSTRAINT chk_contract_format
    CHECK (contract_address ~ '^0x[a-fA-F0-9]{40}$');
