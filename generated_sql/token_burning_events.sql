-- Table: token_burning_events
-- Description: Records all native or smart contract token burns across the Quantora ecosystem.

CREATE TABLE IF NOT EXISTS token_burning_events (
    burn_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_hash TEXT NOT NULL,
    token_address TEXT NOT NULL, -- Can be native or contract address
    from_address TEXT NOT NULL,
    amount_burned NUMERIC(78, 0) NOT NULL CHECK (amount_burned >= 0),
    burn_reason TEXT, -- Optional context (e.g., 'deflation', 'manual_adjustment', 'penalty')
    initiated_by TEXT NOT NULL, -- user, system, smart_contract
    burn_type TEXT NOT NULL CHECK (burn_type IN ('native', 'erc20', 'erc721', 'erc1155')),
    block_number BIGINT NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_burn_token ON token_burning_events(token_address);
CREATE INDEX IF NOT EXISTS idx_burn_from ON token_burning_events(from_address);
CREATE INDEX IF NOT EXISTS idx_burn_block ON token_burning_events(block_number);

COMMENT ON TABLE token_burning_events IS 'Logs all token burning actions (native or contract-based) with reasons and sources.';
COMMENT ON COLUMN token_burning_events.burn_reason IS 'Describes the motivation behind the burn: deflationary control, malicious penalty, manual adjustment, etc.';
