-- ============================================================
-- Table: autonomous_decision_records
-- Purpose: Logs AI/dApp agents' decision-making and actions
-- ============================================================

CREATE TABLE IF NOT EXISTS autonomous_decision_records (
  record_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id            UUID NOT NULL,
  agent_type          VARCHAR(64) NOT NULL, -- e.g. 'trading_bot', 'oracle_ai', 'monitor_agent'
  decision_context    TEXT NOT NULL,        -- JSON description of context/situation
  decision_action     TEXT NOT NULL,        -- JSON or stringified representation of chosen action
  decision_score      NUMERIC,              -- Optional: confidence/priority score
  source_event        UUID,                 -- Optional: event, tx, or user action that triggered decision
  executed_tx_hash    VARCHAR(66),          -- If decision resulted in a blockchain tx
  success             BOOLEAN DEFAULT NULL, -- Whether action succeeded (if applicable)
  reasoning           TEXT,                 -- Optional: agent’s explanation (natural language or structured)
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_autonomous_agent_type   ON autonomous_decision_records(agent_type);
CREATE INDEX IF NOT EXISTS idx_autonomous_created_at   ON autonomous_decision_records(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_autonomous_tx_ref       ON autonomous_decision_records(executed_tx_hash);
