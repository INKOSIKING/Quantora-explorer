-- Table: nft_rights_registry
-- Purpose: Registry for NFT copyrights, usage rights, licenses, and derivative contracts

CREATE TABLE IF NOT EXISTS nft_rights_registry (
    rights_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_token_id TEXT NOT NULL,
    owner_address TEXT NOT NULL,
    license_type TEXT NOT NULL, -- e.g., 'CC BY-NC 4.0', 'Exclusive', 'Royalty-Free'
    rights_scope TEXT NOT NULL, -- e.g., 'Commercial Use', 'Streaming Only'
    jurisdiction TEXT,          -- Optional legal scope
    expiry_date DATE,           -- Rights expiry
    sublicensable BOOLEAN DEFAULT FALSE,
    transferable BOOLEAN DEFAULT TRUE,
    derivative_allowed BOOLEAN DEFAULT FALSE,
    original_contract_hash TEXT,
    rights_metadata JSONB DEFAULT '{}'::jsonb,
    issued_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(nft_token_id, license_type, rights_scope)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_rights_owner ON nft_rights_registry(owner_address);
CREATE INDEX IF NOT EXISTS idx_nft_rights_token ON nft_rights_registry(nft_token_id);
CREATE INDEX IF NOT EXISTS idx_nft_rights_license_type ON nft_rights_registry(license_type);
