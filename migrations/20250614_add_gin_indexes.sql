-- Enable Postgres full-text search for blocks/tx/addresses/contracts
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_blocks_fulltext ON blocks USING gin(to_tsvector('english', block_json));
CREATE INDEX IF NOT EXISTS idx_tx_fulltext ON transactions USING gin(to_tsvector('english', tx_json));
CREATE INDEX IF NOT EXISTS idx_contracts_name ON contracts USING gin(name gin_trgm_ops);

-- For method/event signature lookup
CREATE TABLE IF NOT EXISTS contract_methods (
  id SERIAL PRIMARY KEY,
  contract_address VARCHAR(64),
  signature VARCHAR(128),
  name VARCHAR(64),
  abi JSONB
);
CREATE INDEX IF NOT EXISTS idx_contract_methods_signature ON contract_methods(signature);

CREATE TABLE IF NOT EXISTS contract_events (
  id SERIAL PRIMARY KEY,
  contract_address VARCHAR(64),
  signature VARCHAR(128),
  name VARCHAR(64),
  abi JSONB
);
CREATE INDEX IF NOT EXISTS idx_contract_events_signature ON contract_events(signature);