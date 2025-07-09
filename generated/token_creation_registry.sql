-- =============================================================================
-- 🪙 Table: token_creation_registry
-- 📘 Tracks all token creation events on Quantora chain
-- =============================================================================

CREATE TABLE IF NOT EXISTS token_creation_registry (
  token_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token_name              TEXT NOT NULL,
  symbol                  TEXT NOT NULL,
  token_type              TEXT NOT NULL CHECK (token_type IN ('ERC20', 'ERC721', 'ERC1155', 'custom')),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  creator_wallet          TEXT NOT NULL,
  contract_address        TEXT UNIQUE NOT NULL,
  initial_supply          NUMERIC(78, 0),
  decimals                INT CHECK (decimals >= 0 AND decimals <= 36),
  verified                BOOLEAN DEFAULT FALSE,
  created_via_ai          BOOLEAN DEFAULT FALSE,
  audit_hash              TEXT,
  deployment_tx_hash      TEXT,
  chain_id                TEXT NOT NULL,
  metadata                JSONB,
  notes                   TEXT
);

-- ⚡ Indexes
CREATE INDEX IF NOT EXISTS idx_token_contract ON token_creation_registry(contract_address);
CREATE INDEX IF NOT EXISTS idx_token_creator ON token_creation_registry(creator_wallet);
CREATE INDEX IF NOT EXISTS idx_token_symbol ON token_creation_registry(symbol);
CREATE INDEX IF NOT EXISTS idx_token_created_via_ai ON token_creation_registry(created_via_ai);
