-- Table: nft_transfer_ledger
-- Description: Immutable history of NFT transfers between wallets

CREATE TABLE IF NOT EXISTS nft_transfer_ledger (
    id BIGSERIAL PRIMARY KEY,
    nft_id TEXT NOT NULL,
    token_standard TEXT NOT NULL CHECK (token_standard IN ('ERC721', 'ERC1155', 'Custom')),
    contract_address TEXT NOT NULL,
    from_address TEXT,
    to_address TEXT NOT NULL,
    transfer_type TEXT CHECK (transfer_type IN ('mint', 'transfer', 'burn', 'bridge')) NOT NULL,
    quantity NUMERIC(78, 0) NOT NULL DEFAULT 1,
    tx_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    block_timestamp TIMESTAMPTZ NOT NULL,
    metadata JSONB,
    chain_id TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS uniq_nft_tx ON nft_transfer_ledger(tx_hash, nft_id, from_address, to_address);

CREATE INDEX IF NOT EXISTS idx_nft_transfer_from ON nft_transfer_ledger(from_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_to ON nft_transfer_ledger(to_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_contract ON nft_transfer_ledger(contract_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_chain ON nft_transfer_ledger(chain_id);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_block_time ON nft_transfer_ledger(block_timestamp);

COMMENT ON TABLE nft_transfer_ledger IS 'Ledger tracking all NFT transfers, including mints, transfers, burns, and cross-chain bridges.';
