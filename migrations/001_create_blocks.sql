-- ===================================================================
--  📦 Blocks Table Definition (Production-grade)
-- ===================================================================
CREATE TABLE IF NOT EXISTS blocks (
    block_id            SERIAL PRIMARY KEY,
    block_hash          VARCHAR(66) NOT NULL UNIQUE,
    parent_hash         VARCHAR(66),
    height              BIGINT NOT NULL UNIQUE,
    timestamp           TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
    miner_address       VARCHAR(64),
    state_root          VARCHAR(66),
    transaction_root    VARCHAR(66),
    receipt_root        VARCHAR(66),
    gas_used            BIGINT NOT NULL DEFAULT 0,
    gas_limit           BIGINT NOT NULL,
    difficulty          NUMERIC(30, 0) NOT NULL,
    nonce               VARCHAR(32),
    extra_data          TEXT,
    created_at          TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_blocks_hash ON blocks(block_hash);
CREATE INDEX IF NOT EXISTS idx_blocks_height ON blocks(height);
CREATE INDEX IF NOT EXISTS idx_blocks_miner ON blocks(miner_address);
