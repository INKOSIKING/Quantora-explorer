-- =========================================================
-- 🔗 Table: nft_transfer_graph
-- �� Directed graph edges showing NFT ownership changes
-- =========================================================

CREATE TABLE IF NOT EXISTS nft_transfer_graph (
  edge_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_id                UUID NOT NULL REFERENCES nft_assets(nft_id) ON DELETE CASCADE,
  from_wallet           UUID REFERENCES wallets(wallet_id),
  to_wallet             UUID NOT NULL REFERENCES wallets(wallet_id),
  transaction_hash      TEXT NOT NULL,
  block_number          BIGINT NOT NULL,
  transfer_time         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  gas_used              BIGINT,
  log_index             INTEGER NOT NULL,
  CONSTRAINT nft_transfer_unique_edge UNIQUE (nft_id, transaction_hash, log_index)
);

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_transfer_nft_id ON nft_transfer_graph(nft_id);
CREATE INDEX IF NOT EXISTS idx_transfer_to_wallet ON nft_transfer_graph(to_wallet);
CREATE INDEX IF NOT EXISTS idx_transfer_from_wallet ON nft_transfer_graph(from_wallet);
CREATE INDEX IF NOT EXISTS idx_transfer_block ON nft_transfer_graph(block_number);
