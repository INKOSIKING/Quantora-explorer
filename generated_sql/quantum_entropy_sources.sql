-- Table: quantum_entropy_sources
-- Description: Registry and log of quantum-derived entropy sources for cryptographic operations

CREATE TABLE IF NOT EXISTS quantum_entropy_sources (
    id BIGSERIAL PRIMARY KEY,
    source_name TEXT NOT NULL,
    source_type TEXT NOT NULL CHECK (source_type IN ('hardware', 'cloud', 'satellite', 'hybrid')),
    provider TEXT NOT NULL,
    entropy_bits_collected BIGINT DEFAULT 0,
    entropy_quality_score NUMERIC(5, 2) CHECK (entropy_quality_score BETWEEN 0 AND 100),
    last_validated_at TIMESTAMPTZ,
    health_status TEXT NOT NULL DEFAULT 'healthy' CHECK (health_status IN ('healthy', 'degraded', 'offline')),
    metadata JSONB,
    registered_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_quantum_entropy_source ON quantum_entropy_sources(source_name, provider);

COMMENT ON TABLE quantum_entropy_sources IS 'Quantum randomness providers used by the Quantora platform for entropy-intensive operations.';
