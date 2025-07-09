-- ==============================================================================
-- Table: chain_compression_snapshots
-- Purpose: Store compressed versions of blockchain states (e.g., Merkle roots, ZK-STARKs)
-- Used for lightweight syncing, proof verification, and compression validation
-- ==============================================================================

CREATE TABLE IF NOT EXISTS chain_compression_snapshots (
  snapshot_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  block_hash           VARCHAR(66) NOT NULL,
  block_height         BIGINT NOT NULL,
  compression_method   VARCHAR(64) NOT NULL, -- e.g., 'merkle', 'zk-stark', 'snark', 'lz4'
  compressed_root      TEXT NOT NULL,        -- Merkle root or ZK hash
  snapshot_blob        BYTEA,
  proof_hash           VARCHAR(66),
  validity_proof       BYTEA,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(block_hash, compression_method)
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_chain_compression_block_height ON chain_compression_snapshots(block_height);
CREATE INDEX IF NOT EXISTS idx_chain_compression_method ON chain_compression_snapshots(compression_method);

-- === Constraints ===
ALTER TABLE chain_compression_snapshots
  ADD CONSTRAINT chk_block_hash_format
    CHECK (block_hash ~ '^0x[a-fA-F0-9]{64}$');

ALTER TABLE chain_compression_snapshots
  ADD CONSTRAINT chk_proof_hash_format
    CHECK (proof_hash IS NULL OR proof_hash ~ '^0x[a-fA-F0-9]{64}$');
