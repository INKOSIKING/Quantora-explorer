-- =====================================================================
-- 📦 Table: nft_transfer_logs
-- 🔁 Logs each NFT transfer between wallets with deep traceability
-- =====================================================================

CREATE TABLE IF NOT EXISTS nft_transfer_logs (
  transfer_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token_id             UUID NOT NULL REFERENCES nft_tokens(token_id) ON DELETE CASCADE,
  from_address         TEXT NOT NULL,
  to_address           TEXT NOT NULL,
  tx_hash              TEXT NOT NULL,
  block_number         BIGINT NOT NULL,
  timestamp            TIMESTAMPTZ NOT NULL,
  marketplace          TEXT,
  price_eth            NUMERIC(38, 18),
  usd_price            NUMERIC(38, 2),
  gas_fee_eth          NUMERIC(38, 18),
  method               TEXT,
  is_mint              BOOLEAN DEFAULT FALSE,
  is_burn              BOOLEAN DEFAULT FALSE,
  is_royalty_paid      BOOLEAN DEFAULT FALSE,
  interface_type       TEXT CHECK (interface_type IN ('ERC721', 'ERC1155')),
  metadata_uri         TEXT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 🔍 Indexes for fast querying
CREATE INDEX IF NOT EXISTS idx_nft_transfer_logs_token ON nft_transfer_logs(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_logs_tx_hash ON nft_transfer_logs(tx_hash);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_logs_block_number ON nft_transfer_logs(block_number);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_logs_timestamp ON nft_transfer_logs(timestamp);
