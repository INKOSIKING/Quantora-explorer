-- Table: nft_content_signatures
-- Purpose: Cryptographically bind NFT content (image, video, audio, etc.) to a verifiable hash

CREATE TABLE IF NOT EXISTS nft_content_signatures (
    signature_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_token_id TEXT NOT NULL,
    content_type TEXT NOT NULL, -- image/png, video/mp4, etc.
    content_uri TEXT NOT NULL,
    content_hash TEXT NOT NULL,
    signature_algorithm TEXT NOT NULL DEFAULT 'SHA-256',
    signer_identity TEXT,
    signed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(nft_token_id, content_hash)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_content_hash ON nft_content_signatures(content_hash);
CREATE INDEX IF NOT EXISTS idx_nft_signer ON nft_content_signatures(signer_identity);
