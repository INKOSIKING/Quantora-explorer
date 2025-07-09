-- File: schemas/tokens.sql

CREATE TABLE IF NOT EXISTS tokens (
  address           VARCHAR(66) PRIMARY KEY,
  name              TEXT,
  symbol            TEXT,
  decimals          INTEGER,
  total_supply      NUMERIC(78, 0),
  token_type        TEXT, -- ERC20, ERC721, ERC1155, etc.
  verified          BOOLEAN DEFAULT FALSE,
  logo_url          TEXT,
  website_url       TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔁 Update updated_at automatically
CREATE OR REPLACE FUNCTION update_tokens_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_tokens_updated_at
BEFORE UPDATE ON tokens
FOR EACH ROW EXECUTE FUNCTION update_tokens_updated_at();

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_tokens_symbol ON tokens (symbol);
CREATE INDEX IF NOT EXISTS idx_tokens_type ON tokens (token_type);
CREATE INDEX IF NOT EXISTS idx_tokens_verified ON tokens (verified);

-- 🔒 Address Format Constraint
ALTER TABLE tokens
  ADD CONSTRAINT chk_token_address_format CHECK (address ~ '^0x[a-fA-F0-9]{40}$');
