-- ======================================================================================
-- Table: quantum_inference_chains
-- Purpose: Stores output of quantum simulations, annealing processes, or QML inference
-- ======================================================================================

CREATE TABLE IF NOT EXISTS quantum_inference_chains (
  inference_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name         TEXT NOT NULL,                            -- Name of quantum model or QPU routine
  input_parameters   JSONB NOT NULL,                           -- Problem setup and hyperparameters
  raw_output         JSONB NOT NULL,                           -- Raw quantum output (e.g. bitstrings)
  processed_output   JSONB,                                    -- Post-processed result
  qpu_type           TEXT CHECK (qpu_type IN ('simulator', 'quantum_hardware', 'hybrid')) NOT NULL,
  inference_type     TEXT CHECK (inference_type IN ('optimization', 'classification', 'sampling', 'validation')) NOT NULL,
  executed_by        TEXT,                                     -- Node or oracle that initiated the job
  executed_at        TIMESTAMPTZ DEFAULT NOW(),
  status             TEXT CHECK (status IN ('success', 'error', 'timeout')) DEFAULT 'success',
  error_details      TEXT,
  created_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_qic_model_name ON quantum_inference_chains(model_name);
CREATE INDEX IF NOT EXISTS idx_qic_qpu_type ON quantum_inference_chains(qpu_type);
CREATE INDEX IF NOT EXISTS idx_qic_executed_by ON quantum_inference_chains(executed_by);
CREATE INDEX IF NOT EXISTS idx_qic_status ON quantum_inference_chains(status);
