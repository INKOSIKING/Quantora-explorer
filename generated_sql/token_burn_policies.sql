-- Table: token_burn_policies
-- Description: Configurable rules and metadata for burning tokens on-chain

CREATE TABLE IF NOT EXISTS token_burn_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_address TEXT NOT NULL,
    burn_trigger TEXT NOT NULL, -- e.g., 'tx_fee', 'manual', 'scheduled', 'auto_buyback'
    burn_percentage NUMERIC(10, 4) CHECK (burn_percentage >= 0 AND burn_percentage <= 100),
    min_threshold NUMERIC(30, 8) DEFAULT 0, -- minimum amount for burn to activate
    max_cap NUMERIC(30, 8), -- optional maximum total tokens that can be burned
    cooldown_interval INTERVAL, -- optional interval before next burn can occur
    policy_active BOOLEAN DEFAULT TRUE,
    created_by TEXT,
    approved_by TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_token_burn_policy_token ON token_burn_policies(token_address);

COMMENT ON TABLE token_burn_policies IS 'Defines programmable burn rules and thresholds for tokens in Quantora’s economic model.';
