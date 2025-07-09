-- Generating SQL for table: dapp_session_metrics
-- Table: dapp_session_metrics
-- Purpose: Tracks user sessions and engagement with decentralized applications

CREATE TABLE IF NOT EXISTS dapp_session_metrics (
    session_id UUID PRIMARY KEY,
    wallet_address TEXT NOT NULL,
    dapp_id TEXT NOT NULL,
    user_agent TEXT,
    ip_address INET,
    session_start TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    session_end TIMESTAMPTZ,
    interaction_count INTEGER NOT NULL DEFAULT 0,
    total_data_transferred_bytes BIGINT DEFAULT 0,
    location_geo JSONB,
    device_type TEXT,
    was_authenticated BOOLEAN DEFAULT FALSE,
    session_metadata JSONB,
    risk_score NUMERIC(5,2) DEFAULT 0.00,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_dapp_session_wallet ON dapp_session_metrics(wallet_address);
CREATE INDEX IF NOT EXISTS idx_dapp_session_dapp ON dapp_session_metrics(dapp_id);
CREATE INDEX IF NOT EXISTS idx_dapp_session_times ON dapp_session_metrics(session_start, session_end);
