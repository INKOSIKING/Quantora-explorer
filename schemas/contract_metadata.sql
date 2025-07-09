-- File: schemas/contract_metadata.sql

CREATE TABLE IF NOT EXISTS contract_metadata (
  address            VARCHAR(66) PRIMARY KEY,
  name               TEXT,
  symbol             TEXT,
  decimals           INTEGER,
  contract_type      TEXT, -- ERC20, ERC721, ERC1155, etc.
  verified           BOOLEAN DEFAULT FALSE,
  source_code        TEXT,
  abi_json           JSONB,
  compiler_version   TEXT,
  optimization       BOOLEAN,
  optimization_runs  INTEGER,
  license_type       TEXT,
  creation_tx_hash   VARCHAR(66),
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔁 Auto-update timestamp
CREATE OR REPLACE FUNCTION update_contract_metadata_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_contract_metadata_updated_at
BEFORE UPDATE ON contract_metadata
FOR EACH ROW EXECUTE FUNCTION update_contract_metadata_updated_at();

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_contract_metadata_type ON contract_metadata (contract_type);
CREATE INDEX IF NOT EXISTS idx_contract_metadata_verified ON contract_metadata (verified);

-- 🔒 Format validation
ALTER TABLE contract_metadata
  ADD CONSTRAINT chk_contract_address_format CHECK (address ~ '^0x[a-fA-F0-9]{40}$'),
  ADD CONSTRAINT chk_creation_tx_hash_format CHECK (creation_tx_hash ~ '^0x[a-fA-F0-9]{64}$');
