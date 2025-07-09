-- ─────────────────────────────────────────────────────────────────────────────
-- 📡 META_NETWORK_SENTIMENT_STREAM — Live emotional intelligence layer
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_network_sentiment_stream (
    sentiment_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    observed_at      TIMESTAMPTZ DEFAULT NOW(),
    source_type      TEXT CHECK (source_type IN ('social', 'developer', 'validator', 'dapp')) NOT NULL,
    topic            TEXT,
    raw_input        TEXT,
    sentiment_score  NUMERIC(3,2) CHECK (sentiment_score BETWEEN -1.00 AND 1.00),
    confidence_level NUMERIC(3,2) CHECK (confidence_level BETWEEN 0.00 AND 1.00),
    language_code    TEXT,
    source_reference TEXT
);

CREATE INDEX IF NOT EXISTS idx_sentiment_topic ON meta_network_sentiment_stream(topic);
CREATE INDEX IF NOT EXISTS idx_sentiment_score ON meta_network_sentiment_stream(sentiment_score);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🧬 META_LINGUISTIC_CONTRACT_DECODER — Translates natural language to on-chain execution
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_linguistic_contract_decoder (
    decoder_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_address   VARCHAR(66) NOT NULL,
    natural_input      TEXT NOT NULL,
    decoded_intent     TEXT,
    translated_abi     JSONB,
    semantic_vector    BYTEA,
    decoded_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_decoder_contract ON meta_linguistic_contract_decoder(contract_address);
