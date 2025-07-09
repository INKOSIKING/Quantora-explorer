-- =============================================================================
-- 🖼️ Table: nft_event_log
-- 📘 Logs all NFT-related on-chain events for indexing, compliance, analytics
-- =============================================================================

CREATE TABLE IF NOT EXISTS nft_event_log (
  event_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_id                TEXT NOT NULL,
  token_id              TEXT NOT NULL,
  contract_address      TEXT NOT NULL,
  event_type            TEXT NOT NULL CHECK (event_type IN ('mint', 'transfer', 'burn', 'update')),
  from_address          TEXT,
  to_address            TEXT,
  event_data            JSONB,
  block_number          BIGINT NOT NULL,
  tx_hash               TEXT NOT NULL,
  log_index             INTEGER NOT NULL,
  timestamp             TIMESTAMPTZ NOT NULL,
  chain_id              TEXT NOT NULL,
  UNIQUE(tx_hash, log_index)
);

-- ⚡ Indexes
CREATE INDEX IF NOT EXISTS idx_nft_event_contract ON nft_event_log(contract_address);
CREATE INDEX IF NOT EXISTS idx_nft_event_token_id ON nft_event_log(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_event_type ON nft_event_log(event_type);
CREATE INDEX IF NOT EXISTS idx_nft_event_from_to ON nft_event_log(from_address, to_address);
CREATE INDEX IF NOT EXISTS idx_nft_event_chain_block ON nft_event_log(chain_id, block_number);
