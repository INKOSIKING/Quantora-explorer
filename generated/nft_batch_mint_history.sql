-- =====================================================================
-- 🎨 Table: nft_batch_mint_history
-- 📜 Records historical batch minting operations for NFTs
-- =====================================================================

CREATE TABLE IF NOT EXISTS nft_batch_mint_history (
  batch_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address     TEXT NOT NULL,
  minter_address       TEXT NOT NULL,
  block_number         BIGINT NOT NULL,
  transaction_hash     TEXT NOT NULL,
  mint_count           INTEGER NOT NULL CHECK (mint_count > 0),
  mint_start_token_id  UUID NOT NULL,
  mint_end_token_id    UUID NOT NULL,
  chain_id             TEXT NOT NULL,
  metadata_uri_base    TEXT,
  platform             TEXT,
  mint_reason          TEXT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_batch_mint_contract ON nft_batch_mint_history(contract_address);
CREATE INDEX IF NOT EXISTS idx_nft_batch_minter ON nft_batch_mint_history(minter_address);
CREATE INDEX IF NOT EXISTS idx_nft_batch_chain ON nft_batch_mint_history(chain_id);
