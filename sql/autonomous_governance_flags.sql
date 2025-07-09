-- ==========================================================================
-- Table: autonomous_governance_flags
-- Purpose: Stores automated governance decisions, anomalies, or triggers
-- raised by AI or policy agents in the blockchain network.
-- ==========================================================================

CREATE TABLE IF NOT EXISTS autonomous_governance_flags (
  flag_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  triggered_by      VARCHAR(128) NOT NULL,
  flag_type         VARCHAR(64) NOT NULL CHECK (
                      flag_type IN (
                        'suspicious_activity',
                        'voting_anomaly',
                        'proposal_block',
                        'consensus_violation',
                        'protocol_upgrade_violation'
                      )
                    ),
  severity_level    VARCHAR(16) NOT NULL CHECK (
                      severity_level IN ('low', 'medium', 'high', 'critical')
                    ),
  related_entity    VARCHAR(128),
  entity_type       VARCHAR(32) CHECK (
                      entity_type IN ('wallet', 'contract', 'node', 'proposal', 'validator')
                    ),
  policy_action     VARCHAR(64) CHECK (
                      policy_action IN (
                        'quarantine',
                        'vote_revoke',
                        'penalty',
                        'manual_review',
                        'auto_escalate',
                        'freeze'
                      )
                    ),
  policy_enforced   BOOLEAN NOT NULL DEFAULT FALSE,
  decision_notes    TEXT,
  triggered_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_governance_flag_type     ON autonomous_governance_flags(flag_type);
CREATE INDEX IF NOT EXISTS idx_governance_entity_type   ON autonomous_governance_flags(entity_type);
CREATE INDEX IF NOT EXISTS idx_governance_severity      ON autonomous_governance_flags(severity_level);
CREATE INDEX IF NOT EXISTS idx_governance_triggered_by  ON autonomous_governance_flags(triggered_by);
CREATE INDEX IF NOT EXISTS idx_governance_policy_status ON autonomous_governance_flags(policy_enforced);
