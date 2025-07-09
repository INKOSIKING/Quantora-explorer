-- ================================================================
-- 🔗 Table: cross_chain_consensus_links
-- ================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'cross_chain_consensus_links'
  ) THEN
    CREATE TABLE cross_chain_consensus_links (
      link_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      source_chain         TEXT NOT NULL,
      target_chain         TEXT NOT NULL,
      source_block_hash    TEXT NOT NULL,
      target_block_hash    TEXT NOT NULL,
      source_block_number  BIGINT NOT NULL,
      target_block_number  BIGINT NOT NULL,
      consensus_method     TEXT NOT NULL, -- e.g., 'IBC', 'light-client', 'zk-bridge'
      confidence_score     NUMERIC(5,2), -- 0.00 to 100.00
      finalized            BOOLEAN DEFAULT FALSE,
      inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      metadata             JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_consensus_source_chain ON cross_chain_consensus_links(source_chain);
CREATE INDEX IF NOT EXISTS idx_consensus_target_chain ON cross_chain_consensus_links(target_chain);
CREATE INDEX IF NOT EXISTS idx_consensus_finalized ON cross_chain_consensus_links(finalized);
