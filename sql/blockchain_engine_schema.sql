-- ===============================
-- Schema: Blockchain Engine Core
-- Purpose: Track chain, consensus, blocks, transactions, state
-- ===============================

-- === Blocks ===
CREATE TABLE IF NOT EXISTS blocks (
  block_hash        VARCHAR(66) PRIMARY KEY,
  parent_hash       VARCHAR(66),
  height            BIGINT NOT NULL,
  miner             VARCHAR(66),
  state_root        VARCHAR(66),
  transactions_root VARCHAR(66),
  receipts_root     VARCHAR(66),
  timestamp         TIMESTAMPTZ NOT NULL,
  gas_used          BIGINT,
  gas_limit         BIGINT,
  difficulty        NUMERIC,
  nonce             VARCHAR(32),
  extra_data        TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_blocks_height ON blocks(height);
CREATE INDEX IF NOT EXISTS idx_blocks_miner ON blocks(miner);

-- === Transactions ===
CREATE TABLE IF NOT EXISTS transactions (
  tx_hash        VARCHAR(66) PRIMARY KEY,
  block_hash     VARCHAR(66) REFERENCES blocks(block_hash) ON DELETE CASCADE,
  from_address   VARCHAR(66) NOT NULL,
  to_address     VARCHAR(66),
  value          NUMERIC NOT NULL,
  gas_price      NUMERIC NOT NULL,
  gas_limit      BIGINT NOT NULL,
  nonce          BIGINT NOT NULL,
  input_data     BYTEA,
  timestamp      TIMESTAMPTZ DEFAULT NOW(),
  status         VARCHAR(16) CHECK (status IN ('pending', 'confirmed', 'failed')),
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tx_block_hash     ON transactions(block_hash);
CREATE INDEX IF NOT EXISTS idx_tx_from_address   ON transactions(from_address);
CREATE INDEX IF NOT EXISTS idx_tx_to_address     ON transactions(to_address);

-- === State Snapshots ===
CREATE TABLE IF NOT EXISTS state_snapshots (
  snapshot_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  block_hash     VARCHAR(66) NOT NULL,
  snapshot_data  BYTEA,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

-- === Validators (for PoS) ===
CREATE TABLE IF NOT EXISTS validators (
  validator_address  VARCHAR(66) PRIMARY KEY,
  stake              NUMERIC NOT NULL,
  status             VARCHAR(32) CHECK (status IN ('active', 'inactive', 'slashed')),
  joined_at          TIMESTAMPTZ,
  last_heartbeat     TIMESTAMPTZ,
  updated_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Peers ===
CREATE TABLE IF NOT EXISTS peers (
  peer_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ip_address  INET NOT NULL,
  port        INT NOT NULL,
  node_id     VARCHAR(128),
  last_seen   TIMESTAMPTZ DEFAULT NOW(),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);
