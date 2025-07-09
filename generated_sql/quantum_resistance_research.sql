-- Table: quantum_resistance_research
-- Description: Stores internal and external research logs regarding quantum-safe cryptographic strategies.

CREATE TABLE IF NOT EXISTS quantum_resistance_research (
    research_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL CHECK (category IN ('lattice', 'hash-based', 'multivariate', 'code-based', 'supersingular_isogeny', 'hybrid', 'other')),
    title TEXT NOT NULL,
    authors TEXT[],
    source_url TEXT,
    summary TEXT,
    risk_rating TEXT CHECK (risk_rating IN ('low', 'medium', 'high', 'critical')),
    impacted_components TEXT[], -- Example: ['consensus', 'wallets', 'snarks', 'keys']
    mitigation_proposed BOOLEAN DEFAULT FALSE,
    mitigation_details TEXT,
    published_on DATE,
    reviewed_by TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_qr_category ON quantum_resistance_research(category);
CREATE INDEX IF NOT EXISTS idx_qr_published_on ON quantum_resistance_research(published_on);
CREATE INDEX IF NOT EXISTS idx_qr_risk ON quantum_resistance_research(risk_rating);

COMMENT ON TABLE quantum_resistance_research IS 'Tracks ongoing cryptographic research to ensure the Quantora chain is future-proofed against quantum attacks.';
COMMENT ON COLUMN quantum_resistance_research.category IS 'Cryptographic type being researched: e.g., lattice-based, hash-based, etc.';
COMMENT ON COLUMN quantum_resistance_research.mitigation_details IS 'Details of any implemented or proposed mitigation paths inspired by this research.';
