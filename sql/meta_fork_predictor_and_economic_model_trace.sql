-- ─────────────────────────────────────────────────────────────────────────────
-- 🌉 META_FORK_PREDICTOR — Predict potential forks before they occur
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_fork_predictor (
    prediction_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    predicted_height  BIGINT NOT NULL,
    likelihood_score  NUMERIC(4,3) NOT NULL CHECK (likelihood_score >= 0.000 AND likelihood_score <= 1.000),
    reason_model      TEXT NOT NULL,
    conflicting_nodes TEXT[],
    confidence_class  TEXT CHECK (confidence_class IN ('low', 'moderate', 'high', 'critical')) DEFAULT 'low',
    predicted_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fork_predicted_height ON meta_fork_predictor(predicted_height);
CREATE INDEX IF NOT EXISTS idx_fork_confidence ON meta_fork_predictor(confidence_class);

-- ─────────────────────────────────────────────────────────────────────────────
-- 💰 META_ECONOMIC_MODEL_TRACE — Capture dynamic evolution of tokenomics
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_economic_model_trace (
    trace_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_version     TEXT NOT NULL,
    parameter_name    TEXT NOT NULL,
    previous_value    NUMERIC,
    new_value         NUMERIC,
    rationale         TEXT,
    block_height      BIGINT,
    changed_by        TEXT,
    changed_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_model_trace_version ON meta_economic_model_trace(model_version);
CREATE INDEX IF NOT EXISTS idx_model_trace_param ON meta_economic_model_trace(parameter_name);
