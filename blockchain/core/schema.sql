-- Run this on your Postgres instance to set up blockchain database schema

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS accounts (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    address VARCHAR(64) UNIQUE NOT NULL,
    balance BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS transactions (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    "from" VARCHAR(64) NOT NULL,
    "to" VARCHAR(64) NOT NULL,
    amount BIGINT NOT NULL,
    nonce BIGINT NOT NULL,
    block_hash VARCHAR(128),
    signature TEXT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT now(),
    status VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS blocks (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    hash VARCHAR(128) UNIQUE NOT NULL,
    prev_hash VARCHAR(128) NOT NULL,
    height BIGINT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT now()
);