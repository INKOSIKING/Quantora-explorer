-- ==========================================================================================
-- 🌉 Table: cross_chain_asset_mappings
-- Description: Maintains canonical mapping of tokens and assets across L1s, L2s, and bridges.
-- Supports asset identifiers, bridge contracts, metadata parity, and sync status.
-- ==========================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'cross_chain_asset_mappings'
  ) THEN
    CREATE TABLE cross_chain_asset_mappings (
      mapping_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      source_chain          TEXT NOT NULL,         -- e.g. ethereum
      source_token_address  TEXT NOT NULL,
      destination_chain     TEXT NOT NULL,         -- e.g. polygon
      destination_token_address TEXT NOT NULL,
      bridge_contract       TEXT,
      token_symbol          TEXT,
      token_decimals        INTEGER,
      is_wrapped_asset      BOOLEAN DEFAULT FALSE,
      metadata_match        BOOLEAN DEFAULT TRUE,
      sync_status           TEXT DEFAULT 'synced', -- e.g. 'pending', 'synced', 'failed'
      last_synced_at        TIMESTAMPTZ,
      inserted_at           TIMESTAMPTZ DEFAULT NOW(),
      updated_at            TIMESTAMPTZ
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_cross_chain_pair ON cross_chain_asset_mappings(source_token_address, destination_token_address);
CREATE INDEX IF NOT EXISTS idx_bridge_sync_status ON cross_chain_asset_mappings(sync_status);
CREATE INDEX IF NOT EXISTS idx_chain_pair ON cross_chain_asset_mappings(source_chain, destination_chain);

