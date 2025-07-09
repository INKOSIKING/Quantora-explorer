-- Table: quantum_attack_logs
-- Description: Logs suspected or confirmed quantum attack vectors against blockchain infrastructure

CREATE TABLE IF NOT EXISTS quantum_attack_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attack_type TEXT NOT NULL, -- e.g., key-recovery, signature-forgery, timing-analysis
    description TEXT,
    severity_level TEXT CHECK (severity_level IN ('low', 'moderate', 'high', 'critical')) NOT NULL,
    affected_component TEXT, -- e.g., wallet, consensus, contract
    target_identifier TEXT, -- could be wallet address, contract address, validator ID
    detected_by TEXT, -- e.g., automated-detector, validator-report, audit-tool
    confirmed BOOLEAN DEFAULT FALSE,
    mitigation_action TEXT,
    detection_timestamp TIMESTAMPTZ DEFAULT now(),
    resolved_timestamp TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_quantum_attack_type ON quantum_attack_logs(attack_type);
CREATE INDEX IF NOT EXISTS idx_quantum_attack_component ON quantum_attack_logs(affected_component);
CREATE INDEX IF NOT EXISTS idx_quantum_attack_severity ON quantum_attack_logs(severity_level);

COMMENT ON TABLE quantum_attack_logs IS 'Tracks any incidents or vectors suspected to involve quantum-level cryptographic threats.';
