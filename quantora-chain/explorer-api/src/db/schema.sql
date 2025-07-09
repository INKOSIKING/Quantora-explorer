CREATE TABLE blocks (
  height INTEGER PRIMARY KEY,
  hash TEXT NOT NULL,
  prev_hash TEXT NOT NULL,
  timestamp INTEGER NOT NULL,
  txs TEXT NOT NULL, -- JSON array of tx hashes
  nonce INTEGER NOT NULL
);

CREATE TABLE transactions (
  hash TEXT PRIMARY KEY,
  from_addr TEXT NOT NULL,
  to_addr TEXT NOT NULL,
  value TEXT NOT NULL,
  block_height INTEGER NOT NULL,
  timestamp INTEGER NOT NULL,
  FOREIGN KEY(block_height) REFERENCES blocks(height)
);

CREATE INDEX idx_transactions_block_height ON transactions(block_height);