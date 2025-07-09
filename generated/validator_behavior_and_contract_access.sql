-- 🧠 Table: validator_behavior_summary
CREATE TABLE IF NOT EXISTS validator_behavior_summary (
  summary_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  validator_address VARCHAR(66) NOT NULL,
  epoch_number      BIGINT NOT NULL,
  proposals_made    INTEGER NOT NULL DEFAULT 0,
  votes_cast        INTEGER NOT NULL DEFAULT 0,
  missed_votes      INTEGER NOT NULL DEFAULT 0,
  slashing_events   INTEGER NOT NULL DEFAULT 0,
  gossip_uptime_pct NUMERIC(5,2),
  last_active_at    TIMESTAMPTZ,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_behavior_epoch_validator 
  ON validator_behavior_summary (validator_address, epoch_number);

-- 📡 Table: smart_contract_access_patterns
CREATE TABLE IF NOT EXISTS smart_contract_access_patterns (
  access_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address  VARCHAR(66) NOT NULL,
  accessor_address  VARCHAR(66),
  method_signature  TEXT,
  access_count      BIGINT NOT NULL DEFAULT 0,
  average_gas_used  BIGINT,
  last_accessed_at  TIMESTAMPTZ,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_access_patterns_contract 
  ON smart_contract_access_patterns (contract_address);
CREATE INDEX IF NOT EXISTS idx_access_patterns_accessor 
  ON smart_contract_access_patterns (accessor_address);
