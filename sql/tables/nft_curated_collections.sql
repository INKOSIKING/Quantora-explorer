-- Table: nft_curated_collections
-- Purpose: Stores curated groupings of NFTs based on themes, popularity, curation, or AI.

CREATE TABLE IF NOT EXISTS nft_curated_collections (
    collection_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    cover_image_url TEXT,
    curator_id UUID REFERENCES users(user_id) ON DELETE SET NULL,
    curation_method TEXT NOT NULL DEFAULT 'manual' CHECK (
        curation_method IN ('manual', 'algorithmic', 'ai', 'community')
    ),
    tags TEXT[] DEFAULT '{}',
    is_featured BOOLEAN DEFAULT FALSE,
    metadata JSONB DEFAULT '{}'::jsonb,
    visibility TEXT NOT NULL DEFAULT 'public' CHECK (
        visibility IN ('public', 'private', 'unlisted')
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_curated_collections_slug ON nft_curated_collections(slug);
CREATE INDEX IF NOT EXISTS idx_nft_curated_collections_curator ON nft_curated_collections(curator_id);
CREATE INDEX IF NOT EXISTS idx_nft_curated_collections_tags ON nft_curated_collections USING GIN (tags);
