-- ============================================================================
-- 🧠 Table: ai_model_registry
-- 📘 Registry of AI/ML models deployed or integrated in Quantora
-- ============================================================================

CREATE TABLE IF NOT EXISTS ai_model_registry (
  model_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name        TEXT NOT NULL,
  version           TEXT NOT NULL,
  author_address    TEXT NOT NULL,
  checksum          TEXT NOT NULL,
  storage_uri       TEXT NOT NULL, -- IPFS, Arweave, or internal reference
  description       TEXT,
  framework         TEXT NOT NULL, -- e.g., PyTorch, TensorFlow, ONNX
  license           TEXT,
  ai_type           TEXT CHECK (ai_type IN ('LLM', 'CV', 'RL', 'Custom')),
  model_size_mb     NUMERIC(10,2),
  registered_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_updated_at   TIMESTAMPTZ DEFAULT now(),
  is_active         BOOLEAN DEFAULT true,
  audit_status      TEXT DEFAULT 'pending' -- pending, approved, rejected
);

-- 📌 Indexes
CREATE INDEX IF NOT EXISTS idx_model_registry_name ON ai_model_registry(model_name);
CREATE INDEX IF NOT EXISTS idx_model_registry_author ON ai_model_registry(author_address);
CREATE INDEX IF NOT EXISTS idx_model_registry_audit ON ai_model_registry(audit_status);
