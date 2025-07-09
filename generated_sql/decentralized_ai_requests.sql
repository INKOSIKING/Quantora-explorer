-- Table: decentralized_ai_requests
-- Description: Tracks AI task requests, responses, and verification status for on-chain AI services

CREATE TABLE IF NOT EXISTS decentralized_ai_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    requestor_address TEXT NOT NULL,
    ai_model_id TEXT NOT NULL,
    task_type TEXT NOT NULL, -- e.g., image_classification, code_gen, translation
    input_hash TEXT NOT NULL,
    input_data BYTEA,
    result_hash TEXT,
    result_data BYTEA,
    verifier_address TEXT,
    verified BOOLEAN DEFAULT FALSE,
    model_version TEXT,
    status TEXT CHECK (status IN ('submitted', 'processing', 'completed', 'failed')) DEFAULT 'submitted',
    compute_node TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_ai_requests_requestor ON decentralized_ai_requests(requestor_address);
CREATE INDEX IF NOT EXISTS idx_ai_requests_model_id ON decentralized_ai_requests(ai_model_id);
CREATE INDEX IF NOT EXISTS idx_ai_requests_status ON decentralized_ai_requests(status);
CREATE INDEX IF NOT EXISTS idx_ai_requests_verified ON decentralized_ai_requests(verified);

COMMENT ON TABLE decentralized_ai_requests IS 'Stores on-chain AI task requests, results, and verification metadata for decentralized compute systems.';
