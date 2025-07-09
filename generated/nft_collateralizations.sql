-- =====================================================================
-- 🏦 Table: nft_collateralizations
-- 📜 Tracks NFTs used as collateral in DeFi, lending, or financial services
-- =====================================================================

CREATE TABLE IF NOT EXISTS nft_collateralizations (
  collateralization_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token_id             UUID NOT NULL REFERENCES nft_tokens(token_id) ON DELETE CASCADE,
  nft_owner_address    TEXT NOT NULL,
  protocol_address     TEXT NOT NULL,
  protocol_name        TEXT,
  protocol_type        TEXT CHECK (protocol_type IN ('lending', 'insurance', 'derivatives', 'vault', 'staking')),
  lock_start_block     BIGINT NOT NULL,
  lock_end_block       BIGINT,
  lock_start_time      TIMESTAMPTZ NOT NULL DEFAULT now(),
  unlock_time          TIMESTAMPTZ,
  collateral_value_usd NUMERIC(78, 2),
  liquidation_trigger  BOOLEAN DEFAULT false,
  liquidation_tx_hash  TEXT,
  notes                TEXT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_collateral_token ON nft_collateralizations(token_id);
CREATE INDEX IF NOT EXISTS idx_collateral_owner ON nft_collateralizations(nft_owner_address);
CREATE INDEX IF NOT EXISTS idx_protocol_type ON nft_collateralizations(protocol_type);
