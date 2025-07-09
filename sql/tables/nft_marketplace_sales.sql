-- Table: nft_marketplace_sales
-- Purpose: Logs all completed NFT sales on-chain or off-chain in the Quantora marketplace

CREATE TABLE IF NOT EXISTS nft_marketplace_sales (
    sale_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_id UUID NOT NULL REFERENCES nft_metadata_index(nft_id) ON DELETE CASCADE,
    buyer_wallet_address TEXT NOT NULL,
    seller_wallet_address TEXT NOT NULL,
    sale_price NUMERIC(78, 18) NOT NULL CHECK (sale_price > 0),
    payment_token TEXT NOT NULL, -- e.g. 'ETH', 'QNT', 'USDC'
    transaction_hash TEXT UNIQUE NOT NULL,
    block_number BIGINT NOT NULL,
    sale_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    marketplace_fee_percent NUMERIC(5, 2) DEFAULT 2.5 CHECK (marketplace_fee_percent >= 0 AND marketplace_fee_percent <= 100),
    royalty_fee_percent NUMERIC(5, 2) DEFAULT 5.0 CHECK (royalty_fee_percent >= 0 AND royalty_fee_percent <= 100),
    total_fees NUMERIC(78, 18) GENERATED ALWAYS AS (
        (sale_price * (marketplace_fee_percent + royalty_fee_percent) / 100.0)
    ) STORED,
    net_received_by_seller NUMERIC(78, 18) GENERATED ALWAYS AS (
        (sale_price - total_fees)
    ) STORED,
    status TEXT NOT NULL DEFAULT 'completed' CHECK (status IN ('completed', 'refunded', 'disputed')),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_marketplace_sales_buyer ON nft_marketplace_sales(buyer_wallet_address);
CREATE INDEX IF NOT EXISTS idx_nft_marketplace_sales_seller ON nft_marketplace_sales(seller_wallet_address);
CREATE INDEX IF NOT EXISTS idx_nft_marketplace_sales_txhash ON nft_marketplace_sales(transaction_hash);
CREATE INDEX IF NOT EXISTS idx_nft_marketplace_sales_timestamp ON nft_marketplace_sales(sale_timestamp);
