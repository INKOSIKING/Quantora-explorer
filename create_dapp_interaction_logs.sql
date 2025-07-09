-- ====================================================================================
-- 🧠 Table: dapp_interaction_logs
-- Description: Tracks every user interaction with smart contracts and dApps.
-- ====================================================================================

CREATE TABLE IF NOT EXISTS dapp_interaction_logs (
    interaction_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_address         TEXT NOT NULL,
    contract_address     TEXT NOT NULL,
    method_called        TEXT NOT NULL,
    method_signature     TEXT,
    arguments            JSONB,
    tx_hash              TEXT UNIQUE NOT NULL,
    block_number         BIGINT NOT NULL,
    gas_used             BIGINT,
    success              BOOLEAN DEFAULT TRUE,
    error_message        TEXT,
    timestamp            TIMESTAMPTZ NOT NULL,
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_user_address ON dapp_interaction_logs(user_address);
CREATE INDEX IF NOT EXISTS idx_dapp_contract_address ON dapp_interaction_logs(contract_address);
CREATE INDEX IF NOT EXISTS idx_dapp_method_called ON dapp_interaction_logs(method_called);
CREATE INDEX IF NOT EXISTS idx_dapp_tx_hash ON dapp_interaction_logs(tx_hash);
CREATE INDEX IF NOT EXISTS idx_dapp_block_number ON dapp_interaction_logs(block_number);
