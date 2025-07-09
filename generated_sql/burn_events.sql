-- Table: burn_events
-- Description: Records permanent token removals from circulation across any standard or custom token protocol (ERC-20, native, etc).

CREATE TABLE IF NOT EXISTS burn_events (
    burn_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_address TEXT NOT NULL, -- Contract or native token address
    from_address TEXT NOT NULL, -- Wallet address initiating burn
    amount NUMERIC(78, 0) NOT NULL CHECK (amount > 0),
    transaction_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    burn_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    reason TEXT, -- Optional human description
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    metadata JSONB, -- Extra flexible context for future AI analysis
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_burn_token ON burn_events(token_address);
CREATE INDEX IF NOT EXISTS idx_burn_block ON burn_events(block_number);
CREATE INDEX IF NOT EXISTS idx_burn_tx ON burn_events(transaction_hash);

COMMENT ON TABLE burn_events IS 'Records all on-chain token burning actions with metadata for compliance and audit.';
COMMENT ON COLUMN burn_events.reason IS 'Optional narrative for why the burn occurred.';
COMMENT ON COLUMN burn_events.metadata IS 'Structured extensible metadata for ZK proofs, audit hashes, AI tagging, etc.';
