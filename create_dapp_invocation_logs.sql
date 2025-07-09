-- ==========================================================================================
-- 📡 Table: dapp_invocation_logs
-- Description: Logs every dApp-related smart contract call, user interaction, or invocation
-- ==========================================================================================

CREATE TABLE IF NOT EXISTS dapp_invocation_logs (
    invocation_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dapp_id               UUID NOT NULL,
    user_address          TEXT NOT NULL,
    contract_address      TEXT NOT NULL,
    method_called         TEXT NOT NULL,
    parameters            JSONB,
    gas_used              BIGINT,
    success               BOOLEAN DEFAULT TRUE,
    tx_hash               TEXT,
    block_number          BIGINT,
    called_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    inserted_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (dapp_id) REFERENCES dapp_registry(dapp_id) ON DELETE CASCADE
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_invocations_user ON dapp_invocation_logs(user_address);
CREATE INDEX IF NOT EXISTS idx_dapp_invocations_contract ON dapp_invocation_logs(contract_address);
CREATE INDEX IF NOT EXISTS idx_dapp_invocations_method ON dapp_invocation_logs(method_called);
