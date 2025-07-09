-- File: schemas/chain_reorgs.sql

CREATE TABLE IF NOT EXISTS chain_reorgs (
  reorg_id          BIGSERIAL PRIMARY KEY,
  detected_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  original_block    VARCHAR(66) NOT NULL,
  new_block         VARCHAR(66) NOT NULL,
  common_ancestor   VARCHAR(66) NOT NULL,
  depth             INTEGER NOT NULL,
  reverted_tx_hashes TEXT[] NOT NULL,
  reason            TEXT,
  resolved          BOOLEAN NOT NULL DEFAULT FALSE
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_chain_reorgs_original_block ON chain_reorgs (original_block);
CREATE INDEX IF NOT EXISTS idx_chain_reorgs_new_block ON chain_reorgs (new_block);
CREATE INDEX IF NOT EXISTS idx_chain_reorgs_common_ancestor ON chain_reorgs (common_ancestor);

-- 🔒 Format checks
ALTER TABLE chain_reorgs
  ADD CONSTRAINT chk_original_block_format CHECK (original_block ~ '^0x[a-fA-F0-9]{64}$'),
  ADD CONSTRAINT chk_new_block_format CHECK (new_block ~ '^0x[a-fA-F0-9]{64}$'),
  ADD CONSTRAINT chk_common_ancestor_format CHECK (common_ancestor ~ '^0x[a-fA-F0-9]{64}$');
