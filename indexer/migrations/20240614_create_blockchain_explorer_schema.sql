-- Blockchain explorer schema for robust production indexer

CREATE TABLE IF NOT EXISTS blocks (
    number BIGINT PRIMARY KEY,
    hash VARCHAR(66) NOT NULL UNIQUE,
    parent_hash VARCHAR(66) NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_blocks_timestamp ON blocks (timestamp DESC);

CREATE TABLE IF NOT EXISTS transactions (
    hash VARCHAR(66) PRIMARY KEY,
    block_number BIGINT NOT NULL REFERENCES blocks(number) ON DELETE CASCADE,
    from_addr VARCHAR(42) NOT NULL,
    to_addr VARCHAR(42),
    value VARCHAR(80) NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL,
    input TEXT
);

CREATE INDEX IF NOT EXISTS idx_transactions_from_addr ON transactions (from_addr);
CREATE INDEX IF NOT EXISTS idx_transactions_to_addr ON transactions (to_addr);
CREATE INDEX IF NOT EXISTS idx_transactions_block_number ON transactions (block_number);
CREATE INDEX IF NOT EXISTS idx_transactions_timestamp ON transactions (timestamp DESC);

-- For address balances (optional, if you want fast queries)
CREATE TABLE IF NOT EXISTS address_balances (
    address VARCHAR(42) PRIMARY KEY,
    balance VARCHAR(80) NOT NULL,
    last_updated TIMESTAMPTZ NOT NULL
);

-- For daily stats, precomputed for charts
CREATE TABLE IF NOT EXISTS daily_stats (
    day DATE PRIMARY KEY,
    blocks BIGINT NOT NULL,
    txs BIGINT NOT NULL,
    avg_block_time DOUBLE PRECISION NOT NULL
);