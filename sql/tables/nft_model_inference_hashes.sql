-- Table: nft_model_inference_hashes
-- Purpose: Tracks AI model inference results that influence or verify NFTs (art, traits, attributes, etc.)

CREATE TABLE IF NOT EXISTS nft_model_inference_hashes (
    inference_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_token_id TEXT NOT NULL,
    model_name TEXT NOT NULL,
    model_version TEXT NOT NULL,
    input_signature TEXT NOT NULL,
    output_hash TEXT NOT NULL,
    inference_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    verified BOOLEAN NOT NULL DEFAULT false,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(nft_token_id, model_name, model_version, input_signature)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_inference_model ON nft_model_inference_hashes(model_name, model_version);
CREATE INDEX IF NOT EXISTS idx_nft_inference_verified ON nft_model_inference_hashes(verified);
