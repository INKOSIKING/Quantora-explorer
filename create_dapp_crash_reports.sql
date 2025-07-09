-- ===========================================================================================
-- 💥 Table: dapp_crash_reports
-- Description: Stores critical crash, error, and exception logs for smart contract dApps.
-- ===========================================================================================

CREATE TABLE IF NOT EXISTS dapp_crash_reports (
    crash_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dapp_name             TEXT NOT NULL,
    contract_address      TEXT,
    chain_id              TEXT,
    error_type            TEXT NOT NULL,
    error_message         TEXT NOT NULL,
    stack_trace           TEXT,
    severity              TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')) NOT NULL,
    tx_hash               TEXT,
    triggered_by_wallet   TEXT,
    block_number          BIGINT,
    occurred_at           TIMESTAMPTZ NOT NULL,
    reported_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    metadata              JSONB
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_crash_dapp ON dapp_crash_reports(dapp_name);
CREATE INDEX IF NOT EXISTS idx_dapp_crash_tx ON dapp_crash_reports(tx_hash);
CREATE INDEX IF NOT EXISTS idx_dapp_crash_severity ON dapp_crash_reports(severity);
