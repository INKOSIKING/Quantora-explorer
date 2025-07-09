-- Table: nft_fraud_reports
-- Purpose: Logs fraud or abuse reports associated with specific NFTs or collections.

CREATE TABLE IF NOT EXISTS nft_fraud_reports (
    report_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_address TEXT NOT NULL,
    nft_contract TEXT NOT NULL,
    token_id TEXT NOT NULL,
    report_type TEXT NOT NULL CHECK (report_type IN ('plagiarism', 'duplicate', 'scam', 'stolen', 'fake_metadata', 'phishing', 'impersonation', 'other')),
    description TEXT,
    evidence_links TEXT[],
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'investigating', 'dismissed', 'confirmed_fraud')),
    reviewed_by TEXT,
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_fraud_nft ON nft_fraud_reports(nft_contract, token_id);
CREATE INDEX IF NOT EXISTS idx_nft_fraud_reporter ON nft_fraud_reports(reporter_address);
