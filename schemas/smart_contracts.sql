CREATE TABLE IF NOT EXISTS smart_contracts (
  contract_address   VARCHAR(66) PRIMARY KEY, -- 0x-prefixed 40-byte hex
  deployer_address   VARCHAR(66) NOT NULL,    -- Creator of contract
  bytecode           BYTEA NOT NULL,          -- Raw EVM bytecode
  abi                JSONB,                   -- Optional ABI for decoded interactions
  source_code        TEXT,                    -- Optional verified source
  compiler_version   TEXT,                    -- Compiler version used (e.g., solc 0.8.17)
  optimization_used  BOOLEAN DEFAULT FALSE,   -- Optimization flag
  constructor_args   BYTEA,                   -- Encoded constructor args
  deployed_at_block  BIGINT NOT NULL,         -- Block number of deployment
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🧠 Triggers for updated_at
CREATE OR REPLACE FUNCTION update_smart_contracts_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_smart_contracts_updated_at
BEFORE UPDATE ON smart_contracts
FOR EACH ROW
EXECUTE FUNCTION update_smart_contracts_updated_at();

-- 🔍 Indexes for fast lookup
CREATE INDEX IF NOT EXISTS idx_smart_contracts_deployer ON smart_contracts (deployer_address);
CREATE INDEX IF NOT EXISTS idx_smart_contracts_block ON smart_contracts (deployed_at_block);

-- 🔒 Constraints
ALTER TABLE smart_contracts
  ADD CONSTRAINT chk_contract_address_format CHECK (contract_address ~ '^0x[a-fA-F0-9]{40}$'),
  ADD CONSTRAINT chk_deployer_address_format CHECK (deployer_address ~ '^0x[a-fA-F0-9]{40}$');
