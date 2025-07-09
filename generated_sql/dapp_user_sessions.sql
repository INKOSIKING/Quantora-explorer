-- Table: dapp_user_sessions
-- Description: Tracks wallet-based user sessions within decentralized applications (DApps)

CREATE TABLE IF NOT EXISTS dapp_user_sessions (
    session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_address TEXT NOT NULL,
    dapp_id TEXT NOT NULL,
    session_start TIMESTAMPTZ NOT NULL DEFAULT now(),
    session_end TIMESTAMPTZ,
    interaction_count INTEGER NOT NULL DEFAULT 0,
    ip_address TEXT,
    user_agent TEXT,
    geolocation JSONB,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_active_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(wallet_address, dapp_id, session_start)
);

CREATE INDEX IF NOT EXISTS idx_dapp_sessions_wallet ON dapp_user_sessions(wallet_address);
CREATE INDEX IF NOT EXISTS idx_dapp_sessions_dapp_id ON dapp_user_sessions(dapp_id);
CREATE INDEX IF NOT EXISTS idx_dapp_sessions_active ON dapp_user_sessions(is_active);
CREATE INDEX IF NOT EXISTS idx_dapp_sessions_last_active ON dapp_user_sessions(last_active_at);

COMMENT ON TABLE dapp_user_sessions IS 'Tracks on-chain and off-chain interactions by wallets within DApp sessions.';
