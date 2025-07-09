-- Table: token_burn_intents
-- Description: Records all declared intents to burn tokens, both native and contract-based.

CREATE TABLE IF NOT EXISTS token_burn_intents (
    id BIGSERIAL PRIMARY KEY,
    tx_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    wallet_address TEXT NOT NULL,
    token_address TEXT,
    token_type TEXT NOT NULL CHECK (token_type IN ('native', 'erc20', 'erc721', 'erc1155')),
    amount NUMERIC(78, 0),
    token_id TEXT,
    burn_reason TEXT,
    confirmed BOOLEAN DEFAULT FALSE,
    burn_status TEXT DEFAULT 'pending' CHECK (burn_status IN ('pending', 'completed', 'failed')),
    requested_at TIMESTAMPTZ DEFAULT now(),
    processed_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_burn_wallet ON token_burn_intents(wallet_address);
CREATE INDEX IF NOT EXISTS idx_burn_token_address ON token_burn_intents(token_address);
CREATE INDEX IF NOT EXISTS idx_burn_status ON token_burn_intents(burn_status);

COMMENT ON TABLE token_burn_intents IS 'Tracks all token burn events and their confirmation status, enabling deflationary analytics and regulatory audits.';
