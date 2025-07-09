-- =======================================================================
-- Table: ai_decision_traces
-- Purpose: Captures traceable decision records made by AI agents,
-- including reasoning chain, model version, and decision inputs/outputs.
-- =======================================================================

CREATE TABLE IF NOT EXISTS ai_decision_traces (
  trace_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id           UUID NOT NULL,
  model_name         VARCHAR(128) NOT NULL,
  model_version      VARCHAR(64),
  input_data         JSONB NOT NULL,
  reasoning_chain     JSONB,
  decision_output     JSONB,
  confidence_score   NUMERIC CHECK (confidence_score >= 0 AND confidence_score <= 1),
  decision_type      VARCHAR(64) NOT NULL CHECK (
                       decision_type IN (
                         'trade_execution',
                         'fraud_detection',
                         'governance_vote',
                         'anomaly_flag',
                         'fee_estimation',
                         'oracle_response',
                         'smart_contract_adjustment'
                       )
                     ),
  related_log_id     UUID,
  related_tx_hash    VARCHAR(66),
  created_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_ai_decision_type ON ai_decision_traces(decision_type);
CREATE INDEX IF NOT EXISTS idx_ai_model_name    ON ai_decision_traces(model_name);
CREATE INDEX IF NOT EXISTS idx_ai_agent_id      ON ai_decision_traces(agent_id);

-- === Full-text reasoning search ===
CREATE INDEX IF NOT EXISTS idx_ai_reasoning_fts
  ON ai_decision_traces USING GIN(to_tsvector('english', reasoning_chain::text));

-- === Foreign Keys (optional, soft references) ===
ALTER TABLE ai_decision_traces
  ADD CONSTRAINT fk_ai_decision_log
    FOREIGN KEY (related_log_id) REFERENCES autonomous_agent_logs(log_id) ON DELETE SET NULL;

ALTER TABLE ai_decision_traces
  ADD CONSTRAINT fk_ai_decision_tx
    FOREIGN KEY (related_tx_hash) REFERENCES transactions(tx_hash) ON DELETE SET NULL;

