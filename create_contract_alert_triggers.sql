-- ============================================================================================
-- ⚠️ Table: contract_alert_triggers
-- Description: Defines dynamic alerting conditions for smart contracts based on usage/risk metrics.
-- ============================================================================================

CREATE TABLE IF NOT EXISTS contract_alert_triggers (
    trigger_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_address        TEXT NOT NULL,
    trigger_type            TEXT NOT NULL, -- e.g. 'high_tx_volume', 'code_change', 'balance_drain'
    condition_expression    TEXT NOT NULL, -- e.g. 'tx_count > 1000 AND gas_used > 10000000'
    risk_score              NUMERIC(5,2) DEFAULT 0.00,
    severity_level          TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
    action_policy           TEXT, -- e.g. 'notify', 'block', 'throttle'
    is_active               BOOLEAN DEFAULT TRUE,
    last_triggered_at       TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_contract_alert_address ON contract_alert_triggers(contract_address);
CREATE INDEX IF NOT EXISTS idx_contract_alert_active ON contract_alert_triggers(is_active);
CREATE INDEX IF NOT EXISTS idx_contract_alert_triggered_at ON contract_alert_triggers(last_triggered_at DESC);
