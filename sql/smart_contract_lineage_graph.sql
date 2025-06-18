-- 🔁 SMART_CONTRACT_LINEAGE_GRAPH — Tracks fork & version graph of contracts

CREATE TABLE IF NOT EXISTS smart_contract_lineage_graph (
  lineage_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address    VARCHAR(66) NOT NULL,
  parent_address      VARCHAR(66),
  lineage_type        TEXT CHECK (lineage_type IN ('fork', 'upgrade', 'clone', 'patch')),
  similarity_score    NUMERIC(3,2) CHECK (similarity_score BETWEEN 0.00 AND 1.00),
  commit_hash         TEXT,
  timestamp_created   TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_contract_lineage ON smart_contract_lineage_graph(contract_address);
