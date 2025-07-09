-- Table: usee_accounts
-- Purpose: Core registry for all user accounts on Quantora (wallets, traders, dapp users, etc.)

CREATE TABLE IF NOT EXISTS usee_accounts (
    account_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    public_address         TEXT NOT NULL UNIQUE,
    username               TEXT UNIQUE,
    email                  TEXT UNIQUE,
    account_type           TEXT NOT NULL CHECK (account_type IN ('wallet', 'trader', 'dapp_user', 'contract_owner')),
    created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_active              BOOLEAN NOT NULL DEFAULT TRUE,
    is_smart_contract      BOOLEAN NOT NULL DEFAULT FALSE,
    last_seen_at           TIMESTAMPTZ,
    reputation_score       NUMERIC(5,2) NOT NULL DEFAULT 0.00,
    registered_via         TEXT CHECK (registered_via IN ('web', 'api', 'exchange', 'blockchain', 'wallet_import')),
    metadata               JSONB DEFAULT '{}'::JSONB
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_usee_accounts_created_at ON usee_accounts(created_at);
CREATE INDEX IF NOT EXISTS idx_usee_accounts_is_active ON usee_accounts(is_active);
CREATE INDEX IF NOT EXISTS idx_usee_accounts_account_type ON usee_accounts(account_type);
