-- =====================================================================
-- 💰 Table: nft_royalty_events
-- 📜 Logs all royalty payments triggered by NFT transfers
-- =====================================================================

CREATE TABLE IF NOT EXISTS nft_royalty_events (
  royalty_event_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token_id           UUID NOT NULL REFERENCES nft_tokens(token_id) ON DELETE CASCADE,
  transfer_tx_hash   TEXT NOT NULL,
  block_number       BIGINT NOT NULL,
  royalty_amount     NUMERIC(78, 0) NOT NULL CHECK (royalty_amount >= 0),
  royalty_currency   TEXT NOT NULL DEFAULT 'native',
  payer_address      TEXT NOT NULL,
  recipient_address  TEXT NOT NULL,
  royalty_percentage NUMERIC(5, 2) NOT NULL CHECK (royalty_percentage >= 0 AND royalty_percentage <= 100),
  contract_address   TEXT NOT NULL,
  protocol_name      TEXT,
  protocol_version   TEXT,
  paid_at            TIMESTAMPTZ NOT NULL,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_royalty_token ON nft_royalty_events(token_id);
CREATE INDEX IF NOT EXISTS idx_royalty_recipient ON nft_royalty_events(recipient_address);
CREATE INDEX IF NOT EXISTS idx_royalty_tx ON nft_royalty_events(transfer_tx_hash);
