-- 🛡️ SECURE_RUNTIME_POLICY_ENFORCER — Execution governance and rule injection

CREATE TABLE IF NOT EXISTS secure_runtime_policy_enforcer (
  policy_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scope               TEXT NOT NULL CHECK (scope IN ('contract', 'validator', 'system')),
  rule_name           TEXT NOT NULL,
  description         TEXT,
  condition_logic     TEXT NOT NULL,
  is_enforced         BOOLEAN DEFAULT TRUE,
  enforced_since      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_runtime_policy_scope ON secure_runtime_policy_enforcer(scope);
CREATE INDEX IF NOT EXISTS idx_runtime_policy_rule ON secure_runtime_policy_enforcer(rule_name);
