-- File: schemas/token_transfers.sql

CREATE TABLE IF NOT EXISTS token_transfers (
  transfer_id        BIGSERIAL PRIMARY KEY,
  token_address      VARCHAR(66) NOT NULL,
  from_address       VARCHAR(66) NOT NULL,
  to_address         VARCHAR(66) NOT NULL,
  amount             NUMERIC(78, 0) NOT NULL,
  tx_hash            VARCHAR(66) NOT NULL,
  log_index          INTEGER NOT NULL,
  block_number       BIGINT NOT NULL,
  block_hash         VARCHAR(66) NOT NULL,
  token_type         TEXT NOT NULL CHECK (token_type IN ('ERC20', 'ERC721', 'ERC1155')),
  token_id           NUMERIC(78, 0), -- for ERC721/1155
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes for performance
CREATE INDEX IF NOT EXISTS idx_token_transfers_token ON token_transfers (token_address);
CREATE INDEX IF NOT EXISTS idx_token_transfers_from ON token_transfers (from_address);
CREATE INDEX IF NOT EXISTS idx_token_transfers_to ON token_transfers (to_address);
CREATE INDEX IF NOT EXISTS idx_token_transfers_tx_hash ON token_transfers (tx_hash);
CREATE INDEX IF NOT EXISTS idx_token_transfers_block_number ON token_transfers (block_number);

-- 🔒 Format checks
ALTER TABLE token_transfers
  ADD CONSTRAINT chk_token_address_format CHECK (token_address ~ '^0x[a-fA-F0-9]{40}$'),
  ADD CONSTRAINT chk_from_address_format CHECK (from_address ~ '^0x[a-fA-F0-9]{40}$'),
  ADD CONSTRAINT chk_to_address_format CHECK (to_address ~ '^0x[a-fA-F0-9]{40}$'),
  ADD CONSTRAINT chk_tx_hash_format CHECK (tx_hash ~ '^0x[a-fA-F0-9]{64}$'),
  ADD CONSTRAINT chk_block_hash_format CHECK (block_hash ~ '^0x[a-fA-F0-9]{64}$');
