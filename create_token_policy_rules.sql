-- ========================================================================================
-- 🛡️ Table: token_policy_rules
-- Description: Defines smart token constraints, compliance rules, and policy conditions.
-- ========================================================================================

CREATE TABLE IF NOT EXISTS token_policy_rules (
    rule_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_id               UUID NOT NULL,
    rule_name              TEXT NOT NULL,
    rule_type              TEXT NOT NULL, -- e.g., whitelist_only, transfer_limit, geo_restrict
    config_params          JSONB NOT NULL,
    enforcement_level      TEXT DEFAULT 'advisory', -- advisory | strict | critical
    active                 BOOLEAN DEFAULT TRUE,
    created_by             TEXT,
    created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMPTZ,
    CONSTRAINT fk_policy_token FOREIGN KEY(token_id) REFERENCES tokens(token_id) ON DELETE CASCADE
);

-- �� Indexes
CREATE INDEX IF NOT EXISTS idx_policy_token_id ON token_policy_rules(token_id);
CREATE INDEX IF NOT EXISTS idx_policy_active ON token_policy_rules(active);
CREATE INDEX IF NOT EXISTS idx_policy_rule_type ON token_policy_rules(rule_type);
