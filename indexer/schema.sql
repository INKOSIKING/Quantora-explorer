-- Run this on your Postgres instance to set up indexer database schema

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS indexed_blocks (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    hash VARCHAR(128) UNIQUE NOT NULL,
    prev_hash VARCHAR(128) NOT NULL,
    height BIGINT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS indexed_transactions (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    "from" VARCHAR(64) NOT NULL,
    "to" VARCHAR(64) NOT NULL,
    amount BIGINT NOT NULL,
    block_hash VARCHAR(128) NOT NULL,
    signature TEXT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT now()
);