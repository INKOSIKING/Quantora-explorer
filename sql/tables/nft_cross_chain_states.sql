-- Table: nft_cross_chain_states
-- Purpose: Tracks NFTs as they move across multiple chains or bridges (e.g., Ethereum ↔ Polygon ↔ Solana)

CREATE TABLE IF NOT EXISTS nft_cross_chain_states (
    cross_chain_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_id TEXT NOT NULL,
    contract_address TEXT NOT NULL,
    originating_chain TEXT NOT NULL, -- e.g., 'Ethereum'
    originating_blockchain_id TEXT,
    destination_chain TEXT NOT NULL, -- e.g., 'Polygon'
    destination_blockchain_id TEXT,
    
    bridge_tx_hash TEXT,
    bridge_contract_address TEXT,
    bridge_protocol TEXT, -- e.g., 'Wormhole', 'LayerZero'

    status TEXT NOT NULL CHECK (status IN (
        'pending',
        'bridging',
        'bridged',
        'failed',
        'reverted'
    )),
    failure_reason TEXT,
    
    initiated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at TIMESTAMPTZ,
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_cross_chain_status ON nft_cross_chain_states(status);
CREATE INDEX IF NOT EXISTS idx_nft_cross_chain_token_chain ON nft_cross_chain_states(token_id, originating_chain, destination_chain);
