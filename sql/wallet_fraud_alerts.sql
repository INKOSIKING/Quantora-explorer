-- ==========================================================================================
-- 🚨 Table: wallet_fraud_alerts
-- Description: Records alerts related to potentially fraudulent or suspicious wallet activity.
-- Designed for risk engines, compliance monitoring, and automated fraud detection.
-- ==========================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'wallet_fraud_alerts'
  ) THEN
    CREATE TABLE wallet_fraud_alerts (
      alert_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      wallet_address       TEXT NOT NULL,
      alert_type           TEXT NOT NULL,  -- e.g. 'high_velocity', 'suspicious_token_swap', 'bridge_abuse'
      risk_score           NUMERIC(5,2),   -- 0.00 - 100.00
      triggered_by         TEXT,           -- system, ai_module, analyst
      alert_description    TEXT,
      flagged_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      reviewed             BOOLEAN DEFAULT FALSE,
      resolution_status    TEXT,           -- e.g. 'pending', 'cleared', 'escalated'
      resolved_by          TEXT,
      resolved_at          TIMESTAMPTZ,
      metadata             JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_wallet_alert_wallet ON wallet_fraud_alerts(wallet_address);
CREATE INDEX IF NOT EXISTS idx_wallet_alert_type ON wallet_fraud_alerts(alert_type);
CREATE INDEX IF NOT EXISTS idx_wallet_alert_score ON wallet_fraud_alerts(risk_score);

