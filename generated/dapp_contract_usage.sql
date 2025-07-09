-- =====================================================================
-- 🧩 Table: dapp_contract_usage
-- 📊 Tracks usage patterns of smart contracts associated with DApps
-- =====================================================================

CREATE TABLE IF NOT EXISTS dapp_contract_usage (
  usage_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dapp_name             TEXT NOT NULL,
  contract_address      TEXT NOT NULL,
  user_address          TEXT NOT NULL,
  function_name         TEXT,
  interaction_count     BIGINT NOT NULL DEFAULT 1,
  last_interaction_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  total_gas_used        NUMERIC(30, 0) DEFAULT 0,
  total_tx_fee          NUMERIC(38, 18) DEFAULT 0,
  chain_id              TEXT NOT NULL,
  network               TEXT,
  is_proxy_contract     BOOLEAN DEFAULT FALSE,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_contract ON dapp_contract_usage(contract_address);
CREATE INDEX IF NOT EXISTS idx_dapp_name ON dapp_contract_usage(dapp_name);
CREATE INDEX IF NOT EXISTS idx_dapp_user ON dapp_contract_usage(user_address);
