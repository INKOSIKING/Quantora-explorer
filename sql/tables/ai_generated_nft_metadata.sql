-- Table: ai_generated_nft_metadata
-- Purpose: Stores structured metadata created by AI models and linked to NFTs

CREATE TABLE IF NOT EXISTS ai_generated_nft_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_token_id TEXT NOT NULL,
    ai_model TEXT NOT NULL,
    model_version TEXT NOT NULL,
    generation_method TEXT NOT NULL, -- e.g. 'text2image', 'style-transfer'
    json_metadata JSONB NOT NULL,
    metadata_hash TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(nft_token_id, metadata_hash)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_ai_nft_metadata_token ON ai_generated_nft_metadata(nft_token_id);
CREATE INDEX IF NOT EXISTS idx_ai_nft_metadata_model ON ai_generated_nft_metadata(ai_model, model_version);
