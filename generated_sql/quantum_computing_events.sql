-- Table: quantum_computing_events
-- Description: Logs significant quantum-related blockchain operations, quantum threat simulations, or QKD (quantum key distribution) transitions.

CREATE TABLE IF NOT EXISTS quantum_computing_events (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type TEXT NOT NULL, -- e.g., 'QKD_INITIATED', 'POST_QUANTUM_MIGRATION', 'SIMULATED_Q_ATTACK'
    node_id TEXT NOT NULL, -- Node or validator origin
    impact_scope TEXT NOT NULL CHECK (impact_scope IN ('network-wide', 'shard', 'chain-segment', 'local')),
    quantum_protocol TEXT, -- e.g., 'QKDv2', 'PQ-HSM', 'Lattice-Crypto'
    severity_level TEXT CHECK (severity_level IN ('info', 'warning', 'critical')) DEFAULT 'info',
    metadata JSONB, -- Quantum-specific metrics, performance, errors, etc.
    event_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_quantum_event_type ON quantum_computing_events(event_type);
CREATE INDEX IF NOT EXISTS idx_quantum_node ON quantum_computing_events(node_id);
CREATE INDEX IF NOT EXISTS idx_quantum_time ON quantum_computing_events(event_timestamp);

COMMENT ON TABLE quantum_computing_events IS 'Captures major quantum-computing-related actions, migrations, threats, and system events across the Quantora blockchain.';
COMMENT ON COLUMN quantum_computing_events.metadata IS 'Used for storing additional quantum system data (e.g., entropy rates, QBER, fault-tolerance thresholds, etc).';
