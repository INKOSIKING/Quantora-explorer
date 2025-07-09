-- =====================================================================
-- 🌉 Table: nft_cross_chain_transfer_log
-- 🧾 Tracks cross-chain NFT bridge events and metadata
-- =====================================================================

CREATE TABLE IF NOT EXISTS nft_cross_chain_transfer_log (
  transfer_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_contract_address  TEXT NOT NULL,
  token_id              TEXT NOT NULL,
  from_chain_id         TEXT NOT NULL,
  to_chain_id           TEXT NOT NULL,
  from_address          TEXT NOT NULL,
  to_address            TEXT NOT NULL,
  bridge_protocol       TEXT NOT NULL,
  tx_hash_origin        TEXT NOT NULL,
  tx_hash_destination   TEXT,
  bridged_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  status                TEXT NOT NULL DEFAULT 'pending', -- pending, confirmed, failed
  metadata_uri          TEXT,
  image_url             TEXT,
  collection_name       TEXT,
  retry_count           INTEGER NOT NULL DEFAULT 0,
  last_retry_at         TIMESTAMPTZ,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_bridge_from_chain ON nft_cross_chain_transfer_log(from_chain_id);
CREATE INDEX IF NOT EXISTS idx_nft_bridge_to_chain ON nft_cross_chain_transfer_log(to_chain_id);
CREATE INDEX IF NOT EXISTS idx_nft_bridge_token_id ON nft_cross_chain_transfer_log(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_bridge_status ON nft_cross_chain_transfer_log(status);
