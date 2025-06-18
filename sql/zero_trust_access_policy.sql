-- ─────────────────────────────────────────────────────────────────────────────
-- 🔐 Zero Trust Access: Role-Based Access Control & Endpoint Policies
-- ─────────────────────────────────────────────────────────────────────────────

-- 👤 Table: roles
CREATE TABLE IF NOT EXISTS roles (
  role_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  role_name   TEXT UNIQUE NOT NULL,
  description TEXT
);

-- 🔑 Table: role_assignments
CREATE TABLE IF NOT EXISTS role_assignments (
  assignment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_wallet  TEXT NOT NULL,
  role_id       UUID NOT NULL REFERENCES roles(role_id),
  assigned_at   TIMESTAMPTZ DEFAULT NOW()
);

-- 🧮 Table: service_endpoint_policies
CREATE TABLE IF NOT EXISTS service_endpoint_policies (
  policy_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_name  TEXT NOT NULL,
  endpoint      TEXT NOT NULL,
  method        TEXT CHECK (method IN ('GET', 'POST', 'PUT', 'DELETE')),
  allowed_roles TEXT[] NOT NULL,
  auth_required BOOLEAN DEFAULT true,
  policy_added  TIMESTAMPTZ DEFAULT NOW()
);

-- 📜 Table: access_policy_audit_log
CREATE TABLE IF NOT EXISTS access_policy_audit_log (
  audit_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_wallet  TEXT NOT NULL,
  service_name  TEXT NOT NULL,
  endpoint      TEXT NOT NULL,
  attempted_method TEXT,
  policy_allowed BOOLEAN DEFAULT false,
  evaluated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 🔄 Indexes for high-speed evaluation
CREATE INDEX IF NOT EXISTS idx_role_assignments_wallet ON role_assignments(actor_wallet);
CREATE INDEX IF NOT EXISTS idx_service_policies_service ON service_endpoint_policies(service_name);
CREATE INDEX IF NOT EXISTS idx_access_policy_audit_time ON access_policy_audit_log(evaluated_at);
