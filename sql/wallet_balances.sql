-- Table: wallet_balances
-- Purpose: Tracks current and historical balances for all supported tokens per wallet.

CREATE TABLE IF NOT EXISTS wallet_balances (
    balance_id             BIGSERIAL PRIMARY KEY,
    wallet_address         TEXT NOT NULL,
    token_address          TEXT NOT NULL, -- zero address for native tokens
    token_symbol           TEXT,
    token_decimals         SMALLINT,
    chain_id               TEXT NOT NULL,
    balance                NUMERIC(78, 0) NOT NULL,
    last_updated_block     BIGINT NOT NULL,
    last_updated_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_contract_wallet     BOOLEAN DEFAULT FALSE,
    tags                   TEXT[],
    metadata               JSONB DEFAULT '{}'::JSONB
);

-- Constraints & Indexes
CREATE UNIQUE INDEX IF NOT EXISTS uq_wallet_token_chain ON wallet_balances(wallet_address, token_address, chain_id);
CREATE INDEX IF NOT EXISTS idx_wallet_balance_token ON wallet_balances(token_symbol);
CREATE INDEX IF NOT EXISTS idx_wallet_balance_amount ON wallet_balances(balance DESC);
