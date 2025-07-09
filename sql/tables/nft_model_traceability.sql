-- Table: nft_model_traceability
-- Purpose: Tracks the generation lineage, versions, and source artifacts for AI/3D-generated NFTs

CREATE TABLE IF NOT EXISTS nft_model_traceability (
    trace_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_token_id TEXT NOT NULL,
    model_version TEXT NOT NULL, -- e.g., 'v1.0', 'stable-diffusion-v2.1'
    model_hash TEXT NOT NULL,
    training_data_hash TEXT,
    prompt TEXT,
    seed BIGINT,
    output_resolution TEXT,
    model_type TEXT NOT NULL, -- e.g., 'AI Image', '3D Model'
    generation_time TIMESTAMPTZ NOT NULL DEFAULT now(),
    generated_by TEXT, -- e.g., user address or service ID
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(nft_token_id, model_hash)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_trace_model_type ON nft_model_traceability(model_type);
CREATE INDEX IF NOT EXISTS idx_trace_generated_by ON nft_model_traceability(generated_by);
