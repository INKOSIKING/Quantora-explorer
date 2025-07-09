-- ============================================================
-- Table: quantum_fault_logbook
-- Purpose: Logs fault events, quantum noise, or uncertainty
--          errors from quantum-based components or simulations
-- ============================================================

CREATE TABLE IF NOT EXISTS quantum_fault_logbook (
  fault_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subsystem          VARCHAR(64) NOT NULL,  -- e.g. 'quantum_rng', 'qkd_module', 'zkp_engine'
  fault_type         VARCHAR(64) NOT NULL,  -- e.g. 'decoherence', 'entropy_mismatch', 'timing_skew'
  severity_level     VARCHAR(32) NOT NULL CHECK (severity_level IN ('low', 'medium', 'high', 'critical')),
  detected_by        VARCHAR(128) NOT NULL, -- node, agent, or system reporting fault
  quantum_register   VARCHAR(128),          -- Optional: register or component affected
  timestamp          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  description        TEXT,                  -- Human-readable detail of the anomaly
  recovery_action    TEXT,                  -- Actions taken to stabilize or mitigate
  resolution_status  VARCHAR(32) CHECK (resolution_status IN ('unresolved', 'partial', 'resolved')) DEFAULT 'unresolved'
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_qfault_time           ON quantum_fault_logbook(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_qfault_subsystem      ON quantum_fault_logbook(subsystem);
CREATE INDEX IF NOT EXISTS idx_qfault_severity       ON quantum_fault_logbook(severity_level);
