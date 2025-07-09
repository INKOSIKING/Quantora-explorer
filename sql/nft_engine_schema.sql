-- ========================================
-- Schema: NFT Engine
-- Purpose: Tracks NFTs, metadata, ownership, transfers, collections
-- ========================================

-- === NFT Collections ===
CREATE TABLE IF NOT EXISTS nft_collections (
  collection_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address  VARCHAR(66) UNIQUE NOT NULL,
  name              TEXT,
  symbol            TEXT,
  creator_address   VARCHAR(66),
  total_supply      BIGINT DEFAULT 0,
  is_verified       BOOLEAN DEFAULT FALSE,
  metadata_uri      TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- === NFT Tokens ===
CREATE TABLE IF NOT EXISTS nft_tokens (
  token_uid         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address  VARCHAR(66) NOT NULL,
  token_id          VARCHAR(128) NOT NULL,
  owner_address     VARCHAR(66) NOT NULL,
  metadata_uri      TEXT,
  metadata_json     JSONB,
  minted_at         TIMESTAMPTZ DEFAULT NOW(),
  updated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_nft_token_unique
  ON nft_tokens(contract_address, token_id);

-- === NFT Transfers ===
CREATE TABLE IF NOT EXISTS nft_transfers (
  transfer_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address  VARCHAR(66) NOT NULL,
  token_id          VARCHAR(128) NOT NULL,
  from_address      VARCHAR(66),
  to_address        VARCHAR(66),
  tx_hash           VARCHAR(66),
  block_number      BIGINT,
  transferred_at    TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_nft_transfers_owner ON nft_transfers(to_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfers_token ON nft_transfers(token_id);

-- === Triggers ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_nft_tokens_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_nft_tokens_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trg_nft_tokens_updated_at
    BEFORE UPDATE ON nft_tokens
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_nft_tokens_updated_at();
  END IF;
END
$$;
