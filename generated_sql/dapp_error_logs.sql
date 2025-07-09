-- Table: dapp_error_logs
-- Description: Logs errors, exceptions, and diagnostic issues in DApps

CREATE TABLE IF NOT EXISTS dapp_error_logs (
    id BIGSERIAL PRIMARY KEY,
    dapp_id TEXT NOT NULL,
    wallet_address TEXT,
    error_code TEXT,
    error_message TEXT NOT NULL,
    severity_level TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')) NOT NULL DEFAULT 'medium',
    context JSONB,
    stack_trace TEXT,
    contract_address TEXT,
    function_name TEXT,
    tx_hash TEXT,
    occurred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    resolved BOOLEAN NOT NULL DEFAULT FALSE,
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_dapp_error_logs_dapp ON dapp_error_logs(dapp_id);
CREATE INDEX IF NOT EXISTS idx_dapp_error_logs_tx ON dapp_error_logs(tx_hash);
CREATE INDEX IF NOT EXISTS idx_dapp_error_logs_severity ON dapp_error_logs(severity_level);
CREATE INDEX IF NOT EXISTS idx_dapp_error_logs_unresolved ON dapp_error_logs(resolved) WHERE resolved = false;

COMMENT ON TABLE dapp_error_logs IS 'Detailed error and exception logs for decentralized applications (DApps).';
