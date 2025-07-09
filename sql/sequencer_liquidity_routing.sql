-- ============================================================
-- Schema: Sequencer Liquidity Routing
-- Purpose: Logs routing logic for liquidity-aware sequencer ops
-- ============================================================

CREATE TABLE IF NOT EXISTS sequencer_liquidity_routing (
    route_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sequencer_id        TEXT NOT NULL,
    source_chain        TEXT NOT NULL,
    destination_chain   TEXT NOT NULL,
    routed_liquidity    NUMERIC NOT NULL,
    routing_decision    JSONB NOT NULL,
    latency_ms          INTEGER,
    slippage_estimate   NUMERIC,
    decision_timestamp  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_slr_sequencer ON sequencer_liquidity_routing(sequencer_id);
