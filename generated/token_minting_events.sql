-- =====================================================================
-- 🪙 Table: token_minting_events
-- 🧾 Captures all token creation and minting operations on-chain
-- =====================================================================

CREATE TABLE IF NOT EXISTS token_minting_events (
  mint_event_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token_address        TEXT NOT NULL,
  creator_address      TEXT NOT NULL,
  minter_address       TEXT NOT NULL,
  recipient_address    TEXT NOT NULL,
  amount_minted        NUMERIC(78,0) NOT NULL CHECK (amount_minted >= 0),
  token_symbol         TEXT,
  token_name           TEXT,
  decimals             INTEGER CHECK (decimals >= 0 AND decimals <= 38),
  is_nft               BOOLEAN DEFAULT FALSE,
  tx_hash              TEXT NOT NULL,
  block_number         BIGINT NOT NULL,
  timestamp            TIMESTAMPTZ NOT NULL,
  contract_type        TEXT, -- ERC20, ERC721, ERC1155, custom
  mint_reason          TEXT,
  verified             BOOLEAN DEFAULT FALSE,
  metadata             JSONB,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_minting_token_addr ON token_minting_events(token_address);
CREATE INDEX IF NOT EXISTS idx_minting_creator ON token_minting_events(creator_address);
CREATE INDEX IF NOT EXISTS idx_minting_tx_hash ON token_minting_events(tx_hash);
CREATE INDEX IF NOT EXISTS idx_minting_block_number ON token_minting_events(block_number);
