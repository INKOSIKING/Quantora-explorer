-- ======================================================================
-- Table: autonomous_agent_logs
-- Purpose: Records behavior, decisions, and system actions of autonomous
-- agents interacting with blockchain components, users, or other agents.
-- ======================================================================

CREATE TABLE IF NOT EXISTS autonomous_agent_logs (
  log_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id            UUID NOT NULL,
  agent_type          VARCHAR(64) NOT NULL CHECK (
                        agent_type IN (
                          'trading_bot',
                          'monitoring_daemon',
                          'oracle_handler',
                          'liquidation_agent',
                          'validator_manager',
                          'governance_executor',
                          'zk_verifier',
                          'fraud_detector',
                          'anomaly_scanner'
                        )
                      ),
  decision_context    JSONB,
  decision_output     JSONB,
  log_level           VARCHAR(16) NOT NULL CHECK (
                        log_level IN ('info', 'warn', 'error', 'critical', 'debug')
                      ),
  message             TEXT NOT NULL,
  related_tx_hash     VARCHAR(66),
  block_height        BIGINT,
  system_action       TEXT,
  error_trace         TEXT,
  occurred_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_agent_logs_type      ON autonomous_agent_logs(agent_type);
CREATE INDEX IF NOT EXISTS idx_agent_logs_level     ON autonomous_agent_logs(log_level);
CREATE INDEX IF NOT EXISTS idx_agent_logs_occurred  ON autonomous_agent_logs(occurred_at);
CREATE INDEX IF NOT EXISTS idx_agent_logs_tx_hash   ON autonomous_agent_logs(related_tx_hash);

-- === Full Text Search Support ===
CREATE INDEX IF NOT EXISTS idx_agent_logs_msg_fts
  ON autonomous_agent_logs USING GIN(to_tsvector('english', message));

-- === Constraints ===
ALTER TABLE autonomous_agent_logs
  ADD CONSTRAINT fk_autonomous_agent_logs_tx_hash
  FOREIGN KEY (related_tx_hash) REFERENCES transactions(tx_hash) ON DELETE SET NULL;

