-- ==========================================================================================
-- 📊 Table: dapp_usage_events
-- Description: Tracks granular user activity across dApps on the Quantora blockchain.
-- ==========================================================================================

CREATE TABLE IF NOT EXISTS dapp_usage_events (
    usage_event_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_address         TEXT NOT NULL,
    dapp_id              UUID NOT NULL,
    smart_contract       TEXT NOT NULL,
    function_invoked     TEXT,
    parameters           JSONB,
    success              BOOLEAN DEFAULT TRUE,
    gas_used             BIGINT,
    latency_ms           INTEGER,
    client_metadata      JSONB,
    ip_hash              TEXT,
    event_timestamp      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_dapp_event_dapp FOREIGN KEY(dapp_id) REFERENCES dapps(dapp_id) ON DELETE CASCADE
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_user_address ON dapp_usage_events(user_address);
CREATE INDEX IF NOT EXISTS idx_dapp_event_dapp_id ON dapp_usage_events(dapp_id);
CREATE INDEX IF NOT EXISTS idx_dapp_event_timestamp ON dapp_usage_events(event_timestamp);
