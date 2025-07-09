-- Generating SQL for table: autonomous_agent_logs
-- Table: autonomous_agent_logs
-- Purpose: Logs actions, decisions, and anomalies from autonomous AI agents interacting with the blockchain

CREATE TABLE IF NOT EXISTS autonomous_agent_logs (
    log_id UUID PRIMARY KEY,
    agent_id TEXT NOT NULL,
    agent_type TEXT NOT NULL, -- e.g., market-maker, arbitrage-bot, governance-agent
    session_id TEXT,
    event_type TEXT NOT NULL, -- e.g., action, error, warning, decision
    event_payload JSONB,
    decision_context JSONB,
    tx_hash TEXT,
    related_contract TEXT,
    log_level TEXT CHECK (log_level IN ('INFO', 'WARNING', 'ERROR', 'CRITICAL')) DEFAULT 'INFO',
    memory_snapshot JSONB,
    anomaly_detected BOOLEAN DEFAULT FALSE,
    confidence_score NUMERIC(5,2),
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_autonomous_agent_event_type ON autonomous_agent_logs(event_type);
CREATE INDEX IF NOT EXISTS idx_autonomous_agent_timestamp ON autonomous_agent_logs(timestamp);
CREATE INDEX IF NOT EXISTS idx_autonomous_agent_tx_hash ON autonomous_agent_logs(tx_hash);
