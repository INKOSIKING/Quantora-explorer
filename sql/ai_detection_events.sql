-- ===========================================================================================
-- 🤖 Table: ai_detection_events
-- Description: Logs incidents flagged by AI/ML pipelines — fraud, anomalies, MEV, and wash trades
-- Supports future correlation, investigation, alerting, and forensic analysis.
-- ===========================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_detection_events'
  ) THEN
    CREATE TABLE ai_detection_events (
      detection_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_run_id         UUID REFERENCES ml_model_training_runs(run_id),
      detection_type       TEXT NOT NULL,                  -- e.g., 'fraud', 'wash_trade', 'anomaly'
      confidence_score     NUMERIC(5, 4) NOT NULL,
      related_entity       TEXT,                           -- e.g., wallet address, tx_hash, etc.
      related_entity_type  TEXT,                           -- e.g., 'wallet', 'transaction', 'contract'
      detected_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      context_metadata     JSONB,                          -- any supporting features or metadata
      reviewed             BOOLEAN DEFAULT FALSE,
      reviewed_by          TEXT,
      review_notes         TEXT
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_detection_type ON ai_detection_events(detection_type);
CREATE INDEX IF NOT EXISTS idx_ai_related_entity ON ai_detection_events(related_entity);
CREATE INDEX IF NOT EXISTS idx_ai_detected_at ON ai_detection_events(detected_at);

