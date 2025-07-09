-- Table: nft_physical_delivery_registry
-- Purpose: Tracks delivery and logistics for NFTs representing physical items

CREATE TABLE IF NOT EXISTS nft_physical_delivery_registry (
    delivery_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_token_id TEXT NOT NULL,
    claimed_by_address TEXT NOT NULL,
    delivery_status TEXT NOT NULL DEFAULT 'unclaimed', -- e.g. 'claimed', 'shipped', 'delivered', 'returned'
    delivery_company TEXT,
    tracking_number TEXT UNIQUE,
    shipping_address TEXT,
    shipping_country TEXT,
    customs_declaration JSONB DEFAULT '{}'::jsonb,
    delivery_notes TEXT,
    estimated_delivery_date DATE,
    delivered_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(nft_token_id, claimed_by_address)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_physical_claimed_by ON nft_physical_delivery_registry(claimed_by_address);
CREATE INDEX IF NOT EXISTS idx_nft_physical_token ON nft_physical_delivery_registry(nft_token_id);
CREATE INDEX IF NOT EXISTS idx_nft_physical_status ON nft_physical_delivery_registry(delivery_status);
