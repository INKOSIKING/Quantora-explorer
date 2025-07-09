-- Table: ai_model_registry
-- Description: Registry for AI models integrated into the blockchain environment

CREATE TABLE IF NOT EXISTS ai_model_registry (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_name TEXT NOT NULL,
    version TEXT NOT NULL,
    architecture TEXT NOT NULL, -- e.g., 'transformer', 'cnn', 'rnn', 'diffusion'
    use_case TEXT NOT NULL, -- e.g., 'fraud_detection', 'contract_generation'
    hash_checksum TEXT NOT NULL,
    ipfs_cid TEXT, -- optional decentralized storage reference
    is_active BOOLEAN DEFAULT TRUE,
    authorized_by TEXT,
    deployed_at TIMESTAMPTZ DEFAULT now(),
    last_updated TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_ai_model_name_version ON ai_model_registry(model_name, version);

COMMENT ON TABLE ai_model_registry IS 'Tracks AI models authorized and integrated into the Quantora protocol for autonomous blockchain behavior.';
