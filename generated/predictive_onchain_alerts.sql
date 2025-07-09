-- ============================================================================
-- ⚠️ Table: predictive_onchain_alerts
-- 📘 Forecast-based onchain alerts driven by AI/ML models (price, gas, activity)
-- ============================================================================

CREATE TABLE IF NOT EXISTS predictive_onchain_alerts (
  alert_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  prediction_type     TEXT NOT NULL CHECK (
    prediction_type IN (
      'price_crash', 'volume_spike', 'gas_surge',
      'validator_dropout', 'fork_risk', 'mempool_overload',
      'liquidity_drain', 'whale_move', 'protocol_attack_signal'
    )
  ),
  target_entity       TEXT NOT NULL,
  prediction_window   INTERVAL NOT NULL,
  predicted_confidence NUMERIC(5,4) NOT NULL CHECK (
    predicted_confidence >= 0 AND predicted_confidence <= 1
  ),
  prediction_time     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  forecasted_effect   JSONB DEFAULT '{}'::jsonb,
  ai_model_version    TEXT NOT NULL DEFAULT 'alpha_1.0',
  is_active           BOOLEAN NOT NULL DEFAULT true
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_pred_alerts_type ON predictive_onchain_alerts(prediction_type);
CREATE INDEX IF NOT EXISTS idx_pred_alerts_entity ON predictive_onchain_alerts(target_entity);
CREATE INDEX IF NOT EXISTS idx_pred_alerts_active ON predictive_onchain_alerts(is_active);
