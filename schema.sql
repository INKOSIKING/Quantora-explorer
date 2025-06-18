-- 📜 PQ Validator Registry Table
CREATE TABLE IF NOT EXISTS pq_validator_registry (
    validator_id         UUID PRIMARY KEY,
    node_id              TEXT NOT NULL UNIQUE,
    pq_public_key        TEXT NOT NULL,
    signature_algorithm  TEXT NOT NULL,
    key_type             TEXT DEFAULT 'pq-safe',
    created_at           TIMESTAMPTZ DEFAULT now(),
    metadata             JSONB,
    is_active            BOOLEAN DEFAULT TRUE,
    last_verified_at     TIMESTAMPTZ,
    UNIQUE (pq_public_key)
);
-- Table: ai_model_execution_logs
-- Description: Records AI model inference events, inputs, decisions, and outputs for auditing and diagnostics.

CREATE TABLE IF NOT EXISTS ai_model_execution_logs (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_name TEXT NOT NULL,
    model_version TEXT NOT NULL,
    invocation_id UUID NOT NULL,
    execution_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    input_signature JSONB NOT NULL,
    output_result JSONB NOT NULL,
    decision_summary TEXT,
    confidence_score NUMERIC(5,4),
    latency_ms INTEGER,
    triggered_action TEXT,
    source_module TEXT,
    is_anomaly BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_ai_model_name ON ai_model_execution_logs(model_name);
CREATE INDEX IF NOT EXISTS idx_ai_exec_time ON ai_model_execution_logs(execution_timestamp);
CREATE INDEX IF NOT EXISTS idx_ai_anomaly ON ai_model_execution_logs(is_anomaly);

COMMENT ON TABLE ai_model_execution_logs IS 'Logs AI decisions used in blockchain operations such as fraud detection, routing, or optimization.';
COMMENT ON COLUMN ai_model_execution_logs.input_signature IS 'Serialized representation of AI input.';
COMMENT ON COLUMN ai_model_execution_logs.output_result IS 'Full AI output payload.';
-- Table: ai_model_registry
-- Description: Registry for AI models integrated into the blockchain environment

CREATE TABLE IF NOT EXISTS ai_model_registry (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_name TEXT NOT NULL,
    version TEXT NOT NULL,
    architecture TEXT NOT NULL, -- e.g., 'transformer', 'cnn', 'rnn', 'diffusion'
    use_case TEXT NOT NULL, -- e.g., 'fraud_detection', 'contract_generation'
    hash_checksum TEXT NOT NULL,
    ipfs_cid TEXT, -- optional decentralized storage reference
    is_active BOOLEAN DEFAULT TRUE,
    authorized_by TEXT,
    deployed_at TIMESTAMPTZ DEFAULT now(),
    last_updated TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_ai_model_name_version ON ai_model_registry(model_name, version);

COMMENT ON TABLE ai_model_registry IS 'Tracks AI models authorized and integrated into the Quantora protocol for autonomous blockchain behavior.';
-- Table: burn_events
-- Description: Records permanent token removals from circulation across any standard or custom token protocol (ERC-20, native, etc).

CREATE TABLE IF NOT EXISTS burn_events (
    burn_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_address TEXT NOT NULL, -- Contract or native token address
    from_address TEXT NOT NULL, -- Wallet address initiating burn
    amount NUMERIC(78, 0) NOT NULL CHECK (amount > 0),
    transaction_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    burn_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    reason TEXT, -- Optional human description
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    metadata JSONB, -- Extra flexible context for future AI analysis
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_burn_token ON burn_events(token_address);
CREATE INDEX IF NOT EXISTS idx_burn_block ON burn_events(block_number);
CREATE INDEX IF NOT EXISTS idx_burn_tx ON burn_events(transaction_hash);

COMMENT ON TABLE burn_events IS 'Records all on-chain token burning actions with metadata for compliance and audit.';
COMMENT ON COLUMN burn_events.reason IS 'Optional narrative for why the burn occurred.';
COMMENT ON COLUMN burn_events.metadata IS 'Structured extensible metadata for ZK proofs, audit hashes, AI tagging, etc.';
-- Table: dapp_error_logs
-- Description: Logs errors, exceptions, and diagnostic issues in DApps

CREATE TABLE IF NOT EXISTS dapp_error_logs (
    id BIGSERIAL PRIMARY KEY,
    dapp_id TEXT NOT NULL,
    wallet_address TEXT,
    error_code TEXT,
    error_message TEXT NOT NULL,
    severity_level TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')) NOT NULL DEFAULT 'medium',
    context JSONB,
    stack_trace TEXT,
    contract_address TEXT,
    function_name TEXT,
    tx_hash TEXT,
    occurred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    resolved BOOLEAN NOT NULL DEFAULT FALSE,
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_dapp_error_logs_dapp ON dapp_error_logs(dapp_id);
CREATE INDEX IF NOT EXISTS idx_dapp_error_logs_tx ON dapp_error_logs(tx_hash);
CREATE INDEX IF NOT EXISTS idx_dapp_error_logs_severity ON dapp_error_logs(severity_level);
CREATE INDEX IF NOT EXISTS idx_dapp_error_logs_unresolved ON dapp_error_logs(resolved) WHERE resolved = false;

COMMENT ON TABLE dapp_error_logs IS 'Detailed error and exception logs for decentralized applications (DApps).';
-- Table: dapp_usage_analytics
-- Description: Aggregated performance and usage metrics for dApps on Quantora

CREATE TABLE IF NOT EXISTS dapp_usage_analytics (
    id BIGSERIAL PRIMARY KEY,
    dapp_id UUID NOT NULL,
    date DATE NOT NULL,
    daily_active_users INTEGER DEFAULT 0,
    new_users INTEGER DEFAULT 0,
    total_transactions INTEGER DEFAULT 0,
    average_latency_ms INTEGER DEFAULT 0,
    failed_transactions INTEGER DEFAULT 0,
    gas_consumed NUMERIC(38, 18) DEFAULT 0,
    uptime_percentage NUMERIC(5, 2) DEFAULT 100.00,
    crash_reports JSONB,
    recorded_at TIMESTAMPTZ DEFAULT now(),

    CONSTRAINT fk_dapp_usage_analytics_dapp
        FOREIGN KEY (dapp_id) REFERENCES dapps(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_dapp_usage_analytics_date_dapp ON dapp_usage_analytics(date, dapp_id);

COMMENT ON TABLE dapp_usage_analytics IS 'Daily analytics for dApp usage, stability, and performance on the Quantora blockchain.';
-- Table: dapp_usage_metrics
-- Description: Stores time-series usage metrics for DApps including traffic, transactions, and activity indicators

CREATE TABLE IF NOT EXISTS dapp_usage_metrics (
    id BIGSERIAL PRIMARY KEY,
    dapp_id TEXT NOT NULL,
    metrics_date DATE NOT NULL,
    total_sessions INTEGER NOT NULL DEFAULT 0,
    unique_wallets INTEGER NOT NULL DEFAULT 0,
    total_transactions INTEGER NOT NULL DEFAULT 0,
    average_session_duration INTERVAL,
    gas_consumed NUMERIC(32, 0) DEFAULT 0,
    failed_interactions INTEGER NOT NULL DEFAULT 0,
    api_calls INTEGER DEFAULT 0,
    active_contracts INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(dapp_id, metrics_date)
);

CREATE INDEX IF NOT EXISTS idx_dapp_usage_metrics_dapp_date ON dapp_usage_metrics(dapp_id, metrics_date);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_metrics_wallets ON dapp_usage_metrics(unique_wallets DESC);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_metrics_sessions ON dapp_usage_metrics(total_sessions DESC);

COMMENT ON TABLE dapp_usage_metrics IS 'Time-series usage metrics for DApps across sessions, wallets, and performance dimensions.';
-- Table: dapp_user_sessions
-- Description: Tracks wallet-based user sessions within decentralized applications (DApps)

CREATE TABLE IF NOT EXISTS dapp_user_sessions (
    session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_address TEXT NOT NULL,
    dapp_id TEXT NOT NULL,
    session_start TIMESTAMPTZ NOT NULL DEFAULT now(),
    session_end TIMESTAMPTZ,
    interaction_count INTEGER NOT NULL DEFAULT 0,
    ip_address TEXT,
    user_agent TEXT,
    geolocation JSONB,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_active_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(wallet_address, dapp_id, session_start)
);

CREATE INDEX IF NOT EXISTS idx_dapp_sessions_wallet ON dapp_user_sessions(wallet_address);
CREATE INDEX IF NOT EXISTS idx_dapp_sessions_dapp_id ON dapp_user_sessions(dapp_id);
CREATE INDEX IF NOT EXISTS idx_dapp_sessions_active ON dapp_user_sessions(is_active);
CREATE INDEX IF NOT EXISTS idx_dapp_sessions_last_active ON dapp_user_sessions(last_active_at);

COMMENT ON TABLE dapp_user_sessions IS 'Tracks on-chain and off-chain interactions by wallets within DApp sessions.';
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
-- Table: nft_batch_minting
-- Description: Tracks batched NFT minting operations including metadata, execution status, and sources.

CREATE TABLE IF NOT EXISTS nft_batch_minting (
    batch_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_wallet_address TEXT NOT NULL,
    total_nfts INTEGER NOT NULL,
    metadata_uri TEXT,
    execution_status TEXT NOT NULL DEFAULT 'pending', -- pending | processing | completed | failed
    minting_tx_hash TEXT,
    scheduled_at TIMESTAMPTZ DEFAULT now(),
    executed_at TIMESTAMPTZ,
    failure_reason TEXT,
    mint_type TEXT DEFAULT 'bulk', -- single | bulk | programmatic
    originating_dapp TEXT,
    estimated_gas NUMERIC(20,8),
    actual_gas_used NUMERIC(20,8),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_nft_batch_creator ON nft_batch_minting(creator_wallet_address);
CREATE INDEX IF NOT EXISTS idx_nft_batch_status ON nft_batch_minting(execution_status);
CREATE INDEX IF NOT EXISTS idx_nft_minting_time ON nft_batch_minting(scheduled_at);

COMMENT ON TABLE nft_batch_minting IS 'Logs mass NFT minting sessions and their metadata, used for batch diagnostics and DApp analytics.';
-- Table: nft_collection_registry
-- Description: Stores metadata and management info for NFT collections deployed on-chain.

CREATE TABLE IF NOT EXISTS nft_collection_registry (
    id BIGSERIAL PRIMARY KEY,
    collection_address TEXT UNIQUE NOT NULL,
    creator_address TEXT NOT NULL,
    name TEXT NOT NULL,
    symbol TEXT NOT NULL,
    base_uri TEXT,
    total_supply BIGINT DEFAULT 0,
    chain_id TEXT NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    created_block BIGINT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_nft_creator ON nft_collection_registry(creator_address);
CREATE INDEX IF NOT EXISTS idx_nft_verified ON nft_collection_registry(verified);
CREATE INDEX IF NOT EXISTS idx_nft_chain_id ON nft_collection_registry(chain_id);

COMMENT ON TABLE nft_collection_registry IS 'Registry for NFT collections deployed on the chain, with creator, supply, and URI metadata.';
-- Table: nft_marketplace_events
-- Description: Captures event activity on NFT marketplaces: listings, bids, purchases, etc.

CREATE TABLE IF NOT EXISTS nft_marketplace_events (
    id BIGSERIAL PRIMARY KEY,
    event_type TEXT NOT NULL CHECK (event_type IN ('listed', 'delisted', 'bid', 'cancel_bid', 'sold', 'transferred')),
    marketplace TEXT NOT NULL,
    collection_address TEXT NOT NULL,
    token_id TEXT NOT NULL,
    seller_address TEXT,
    buyer_address TEXT,
    price NUMERIC(78, 0),
    currency TEXT,
    tx_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    event_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB,
    UNIQUE(event_type, tx_hash, token_id, block_number)
);

CREATE INDEX IF NOT EXISTS idx_nft_mkt_event_type ON nft_marketplace_events(event_type);
CREATE INDEX IF NOT EXISTS idx_nft_mkt_collection_token ON nft_marketplace_events(collection_address, token_id);
CREATE INDEX IF NOT EXISTS idx_nft_mkt_tx_hash ON nft_marketplace_events(tx_hash);
CREATE INDEX IF NOT EXISTS idx_nft_mkt_event_time ON nft_marketplace_events(event_timestamp);

COMMENT ON TABLE nft_marketplace_events IS 'Logs NFT marketplace activity including sales, bids, and listings.';
-- Table: nft_token_ownership
-- Description: Tracks ownership and metadata of individual NFTs per collection.

CREATE TABLE IF NOT EXISTS nft_token_ownership (
    id BIGSERIAL PRIMARY KEY,
    token_id TEXT NOT NULL,
    collection_address TEXT NOT NULL,
    owner_address TEXT NOT NULL,
    metadata_uri TEXT,
    minted_block BIGINT,
    burned BOOLEAN DEFAULT FALSE,
    burn_reason TEXT,
    last_transfer_tx_hash TEXT,
    last_transfer_block BIGINT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(token_id, collection_address)
);

CREATE INDEX IF NOT EXISTS idx_nft_owner ON nft_token_ownership(owner_address);
CREATE INDEX IF NOT EXISTS idx_nft_token_id ON nft_token_ownership(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_collection ON nft_token_ownership(collection_address);
CREATE INDEX IF NOT EXISTS idx_nft_burned ON nft_token_ownership(burned);

COMMENT ON TABLE nft_token_ownership IS 'Tracks who owns which NFT tokens and relevant transfer/burn metadata.';
-- Table: nft_transfer_ledger
-- Description: Immutable history of NFT transfers between wallets

CREATE TABLE IF NOT EXISTS nft_transfer_ledger (
    id BIGSERIAL PRIMARY KEY,
    nft_id TEXT NOT NULL,
    token_standard TEXT NOT NULL CHECK (token_standard IN ('ERC721', 'ERC1155', 'Custom')),
    contract_address TEXT NOT NULL,
    from_address TEXT,
    to_address TEXT NOT NULL,
    transfer_type TEXT CHECK (transfer_type IN ('mint', 'transfer', 'burn', 'bridge')) NOT NULL,
    quantity NUMERIC(78, 0) NOT NULL DEFAULT 1,
    tx_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    block_timestamp TIMESTAMPTZ NOT NULL,
    metadata JSONB,
    chain_id TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS uniq_nft_tx ON nft_transfer_ledger(tx_hash, nft_id, from_address, to_address);

CREATE INDEX IF NOT EXISTS idx_nft_transfer_from ON nft_transfer_ledger(from_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_to ON nft_transfer_ledger(to_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_contract ON nft_transfer_ledger(contract_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_chain ON nft_transfer_ledger(chain_id);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_block_time ON nft_transfer_ledger(block_timestamp);

COMMENT ON TABLE nft_transfer_ledger IS 'Ledger tracking all NFT transfers, including mints, transfers, burns, and cross-chain bridges.';
-- Table: post_quantum_transaction_signatures
-- Description: Stores metadata about post-quantum cryptographic signatures used in blockchain transactions

CREATE TABLE IF NOT EXISTS post_quantum_transaction_signatures (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_hash TEXT NOT NULL,
    signature_algorithm TEXT NOT NULL, -- e.g., Dilithium, Falcon, SPHINCS+
    signature BYTEA NOT NULL,
    public_key BYTEA NOT NULL,
    key_type TEXT CHECK (key_type IN ('public', 'hybrid', 'threshold')) DEFAULT 'public',
    is_valid BOOLEAN DEFAULT TRUE,
    verified_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_pq_tx_signature_txhash ON post_quantum_transaction_signatures(tx_hash);
CREATE INDEX IF NOT EXISTS idx_pq_signature_algo ON post_quantum_transaction_signatures(signature_algorithm);
CREATE INDEX IF NOT EXISTS idx_pq_signature_validity ON post_quantum_transaction_signatures(is_valid);

COMMENT ON TABLE post_quantum_transaction_signatures IS 'Captures post-quantum secure signatures associated with blockchain transactions for validation and audit.';
-- Table: post_quantum_wallet_flags
-- Description: Tracks wallets marked with quantum-safety metadata and cryptographic capabilities

CREATE TABLE IF NOT EXISTS post_quantum_wallet_flags (
    wallet_address TEXT PRIMARY KEY,
    uses_post_quantum_cryptography BOOLEAN DEFAULT FALSE,
    pq_algorithm TEXT, -- e.g., CRYSTALS-Kyber, Falcon, SPHINCS+
    fallback_curve TEXT, -- e.g., secp256k1, ed25519
    quantum_hardened_since TIMESTAMPTZ,
    wallet_provider TEXT,
    audit_certified BOOLEAN DEFAULT FALSE,
    certification_entity TEXT,
    last_verified TIMESTAMPTZ,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_pq_wallet_algo ON post_quantum_wallet_flags(pq_algorithm);
CREATE INDEX IF NOT EXISTS idx_pq_wallet_certified ON post_quantum_wallet_flags(audit_certified);
CREATE INDEX IF NOT EXISTS idx_pq_wallet_verified ON post_quantum_wallet_flags(last_verified);

COMMENT ON TABLE post_quantum_wallet_flags IS 'Flags and verifies wallets that implement post-quantum cryptographic schemes and standards.';
-- Table: quantum_attack_logs
-- Description: Logs suspected or confirmed quantum attack vectors against blockchain infrastructure

CREATE TABLE IF NOT EXISTS quantum_attack_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attack_type TEXT NOT NULL, -- e.g., key-recovery, signature-forgery, timing-analysis
    description TEXT,
    severity_level TEXT CHECK (severity_level IN ('low', 'moderate', 'high', 'critical')) NOT NULL,
    affected_component TEXT, -- e.g., wallet, consensus, contract
    target_identifier TEXT, -- could be wallet address, contract address, validator ID
    detected_by TEXT, -- e.g., automated-detector, validator-report, audit-tool
    confirmed BOOLEAN DEFAULT FALSE,
    mitigation_action TEXT,
    detection_timestamp TIMESTAMPTZ DEFAULT now(),
    resolved_timestamp TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_quantum_attack_type ON quantum_attack_logs(attack_type);
CREATE INDEX IF NOT EXISTS idx_quantum_attack_component ON quantum_attack_logs(affected_component);
CREATE INDEX IF NOT EXISTS idx_quantum_attack_severity ON quantum_attack_logs(severity_level);

COMMENT ON TABLE quantum_attack_logs IS 'Tracks any incidents or vectors suspected to involve quantum-level cryptographic threats.';
-- Table: quantum_computing_events
-- Description: Logs significant quantum-related blockchain operations, quantum threat simulations, or QKD (quantum key distribution) transitions.

CREATE TABLE IF NOT EXISTS quantum_computing_events (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type TEXT NOT NULL, -- e.g., 'QKD_INITIATED', 'POST_QUANTUM_MIGRATION', 'SIMULATED_Q_ATTACK'
    node_id TEXT NOT NULL, -- Node or validator origin
    impact_scope TEXT NOT NULL CHECK (impact_scope IN ('network-wide', 'shard', 'chain-segment', 'local')),
    quantum_protocol TEXT, -- e.g., 'QKDv2', 'PQ-HSM', 'Lattice-Crypto'
    severity_level TEXT CHECK (severity_level IN ('info', 'warning', 'critical')) DEFAULT 'info',
    metadata JSONB, -- Quantum-specific metrics, performance, errors, etc.
    event_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_quantum_event_type ON quantum_computing_events(event_type);
CREATE INDEX IF NOT EXISTS idx_quantum_node ON quantum_computing_events(node_id);
CREATE INDEX IF NOT EXISTS idx_quantum_time ON quantum_computing_events(event_timestamp);

COMMENT ON TABLE quantum_computing_events IS 'Captures major quantum-computing-related actions, migrations, threats, and system events across the Quantora blockchain.';
COMMENT ON COLUMN quantum_computing_events.metadata IS 'Used for storing additional quantum system data (e.g., entropy rates, QBER, fault-tolerance thresholds, etc).';
-- Table: quantum_entropy_sources
-- Description: Registry and log of quantum-derived entropy sources for cryptographic operations

CREATE TABLE IF NOT EXISTS quantum_entropy_sources (
    id BIGSERIAL PRIMARY KEY,
    source_name TEXT NOT NULL,
    source_type TEXT NOT NULL CHECK (source_type IN ('hardware', 'cloud', 'satellite', 'hybrid')),
    provider TEXT NOT NULL,
    entropy_bits_collected BIGINT DEFAULT 0,
    entropy_quality_score NUMERIC(5, 2) CHECK (entropy_quality_score BETWEEN 0 AND 100),
    last_validated_at TIMESTAMPTZ,
    health_status TEXT NOT NULL DEFAULT 'healthy' CHECK (health_status IN ('healthy', 'degraded', 'offline')),
    metadata JSONB,
    registered_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_quantum_entropy_source ON quantum_entropy_sources(source_name, provider);

COMMENT ON TABLE quantum_entropy_sources IS 'Quantum randomness providers used by the Quantora platform for entropy-intensive operations.';
-- Table: quantum_key_management
-- Description: Registry for managing lifecycle and metadata of quantum-resistant cryptographic keys.

CREATE TABLE IF NOT EXISTS quantum_key_management (
    key_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    associated_wallet TEXT NOT NULL,
    public_key TEXT NOT NULL,
    key_type TEXT CHECK (key_type IN ('Dilithium', 'SPHINCS+', 'Falcon', 'Kyber', 'Hybrid', 'Other')) NOT NULL,
    key_usage TEXT CHECK (key_usage IN ('transaction_signing', 'contract_deployment', 'data_encryption')) NOT NULL,
    valid_from TIMESTAMPTZ NOT NULL,
    valid_until TIMESTAMPTZ,
    is_revoked BOOLEAN NOT NULL DEFAULT FALSE,
    revoked_reason TEXT,
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_qkm_wallet ON quantum_key_management(associated_wallet);
CREATE INDEX IF NOT EXISTS idx_qkm_key_type ON quantum_key_management(key_type);
CREATE INDEX IF NOT EXISTS idx_qkm_validity ON quantum_key_management(valid_from, valid_until);
CREATE INDEX IF NOT EXISTS idx_qkm_revoked ON quantum_key_management(is_revoked);

COMMENT ON TABLE quantum_key_management IS 'Tracks post-quantum key material and lifecycle used for secure blockchain operations.';
COMMENT ON COLUMN quantum_key_management.key_type IS 'Algorithm used for quantum-safe operations.';
COMMENT ON COLUMN quantum_key_management.is_revoked IS 'Indicates whether the key was revoked.';
-- Table: quantum_key_rotation_logs
-- Description: Audits all key rotation events especially those aligned with post-quantum cryptographic standards.

CREATE TABLE IF NOT EXISTS quantum_key_rotation_logs (
    rotation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_address TEXT NOT NULL,
    old_public_key TEXT NOT NULL,
    new_public_key TEXT NOT NULL,
    quantum_resistant BOOLEAN NOT NULL DEFAULT FALSE,
    reason TEXT,
    rotated_by TEXT, -- Could be user, system, or guardian contract
    rotation_method TEXT CHECK (rotation_method IN ('automated', 'manual', 'scheduled', 'emergency')),
    rotation_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    network TEXT DEFAULT 'mainnet'
);

CREATE INDEX IF NOT EXISTS idx_qkrl_wallet ON quantum_key_rotation_logs(wallet_address);
CREATE INDEX IF NOT EXISTS idx_qkrl_timestamp ON quantum_key_rotation_logs(rotation_timestamp);
CREATE INDEX IF NOT EXISTS idx_qkrl_quantum_resistance ON quantum_key_rotation_logs(quantum_resistant);

COMMENT ON TABLE quantum_key_rotation_logs IS 'Lifecycle audit trail for quantum-aware key rotations across wallets on the Quantora chain.';
COMMENT ON COLUMN quantum_key_rotation_logs.quantum_resistant IS 'Whether the new key complies with quantum-safe cryptography.';
-- Table: quantum_resistance_research
-- Description: Stores internal and external research logs regarding quantum-safe cryptographic strategies.

CREATE TABLE IF NOT EXISTS quantum_resistance_research (
    research_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL CHECK (category IN ('lattice', 'hash-based', 'multivariate', 'code-based', 'supersingular_isogeny', 'hybrid', 'other')),
    title TEXT NOT NULL,
    authors TEXT[],
    source_url TEXT,
    summary TEXT,
    risk_rating TEXT CHECK (risk_rating IN ('low', 'medium', 'high', 'critical')),
    impacted_components TEXT[], -- Example: ['consensus', 'wallets', 'snarks', 'keys']
    mitigation_proposed BOOLEAN DEFAULT FALSE,
    mitigation_details TEXT,
    published_on DATE,
    reviewed_by TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_qr_category ON quantum_resistance_research(category);
CREATE INDEX IF NOT EXISTS idx_qr_published_on ON quantum_resistance_research(published_on);
CREATE INDEX IF NOT EXISTS idx_qr_risk ON quantum_resistance_research(risk_rating);

COMMENT ON TABLE quantum_resistance_research IS 'Tracks ongoing cryptographic research to ensure the Quantora chain is future-proofed against quantum attacks.';
COMMENT ON COLUMN quantum_resistance_research.category IS 'Cryptographic type being researched: e.g., lattice-based, hash-based, etc.';
COMMENT ON COLUMN quantum_resistance_research.mitigation_details IS 'Details of any implemented or proposed mitigation paths inspired by this research.';
-- Table: quantum_resistant_contracts
-- Description: Metadata registry for smart contracts designed or migrated with post-quantum cryptographic protections.

CREATE TABLE IF NOT EXISTS quantum_resistant_contracts (
    contract_address TEXT PRIMARY KEY,
    deployed_by TEXT NOT NULL,
    quantum_safe BOOLEAN NOT NULL DEFAULT FALSE,
    hash_algorithm TEXT CHECK (hash_algorithm IN ('SHA3', 'Blake3', 'SPHINCS+', 'Dilithium', 'Other')),
    quantum_algorithm_details TEXT,
    verification_mechanism TEXT,
    source_code_hash TEXT,
    audit_status TEXT CHECK (audit_status IN ('unaudited', 'pending', 'verified', 'flagged')) DEFAULT 'unaudited',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_qrc_deployer ON quantum_resistant_contracts(deployed_by);
CREATE INDEX IF NOT EXISTS idx_qrc_created ON quantum_resistant_contracts(created_at);
CREATE INDEX IF NOT EXISTS idx_qrc_audit_status ON quantum_resistant_contracts(audit_status);
CREATE INDEX IF NOT EXISTS idx_qrc_qsafe ON quantum_resistant_contracts(quantum_safe);

COMMENT ON TABLE quantum_resistant_contracts IS 'Registry of contracts secured with post-quantum mechanisms or flagged for migration.';
COMMENT ON COLUMN quantum_resistant_contracts.hash_algorithm IS 'Indicates the post-quantum algorithm used for signing or verifying.';
-- Table: quantum_validation_attempts
-- Description: Tracks quantum algorithm or oracle-based validations attempted on-chain/off-chain.

CREATE TABLE IF NOT EXISTS quantum_validation_attempts (
    id BIGSERIAL PRIMARY KEY,
    validator_id UUID,
    block_number BIGINT NOT NULL,
    quantum_algorithm TEXT NOT NULL,
    challenge_input TEXT NOT NULL,
    result_output TEXT,
    passed BOOLEAN,
    error_message TEXT,
    cpu_time_ms INT,
    quantum_cycles_estimate BIGINT,
    attempted_at TIMESTAMPTZ DEFAULT now(),
    validated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_qv_validator ON quantum_validation_attempts(validator_id);
CREATE INDEX IF NOT EXISTS idx_qv_algorithm ON quantum_validation_attempts(quantum_algorithm);
CREATE INDEX IF NOT EXISTS idx_qv_result ON quantum_validation_attempts(passed);

COMMENT ON TABLE quantum_validation_attempts IS 'Logs all quantum-computing validation processes, useful for post-quantum cryptographic evaluation and quantum oracle research.';
-- Table: token_burn_intents
-- Description: Records all declared intents to burn tokens, both native and contract-based.

CREATE TABLE IF NOT EXISTS token_burn_intents (
    id BIGSERIAL PRIMARY KEY,
    tx_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    wallet_address TEXT NOT NULL,
    token_address TEXT,
    token_type TEXT NOT NULL CHECK (token_type IN ('native', 'erc20', 'erc721', 'erc1155')),
    amount NUMERIC(78, 0),
    token_id TEXT,
    burn_reason TEXT,
    confirmed BOOLEAN DEFAULT FALSE,
    burn_status TEXT DEFAULT 'pending' CHECK (burn_status IN ('pending', 'completed', 'failed')),
    requested_at TIMESTAMPTZ DEFAULT now(),
    processed_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_burn_wallet ON token_burn_intents(wallet_address);
CREATE INDEX IF NOT EXISTS idx_burn_token_address ON token_burn_intents(token_address);
CREATE INDEX IF NOT EXISTS idx_burn_status ON token_burn_intents(burn_status);

COMMENT ON TABLE token_burn_intents IS 'Tracks all token burn events and their confirmation status, enabling deflationary analytics and regulatory audits.';
-- Table: token_burn_policies
-- Description: Configurable rules and metadata for burning tokens on-chain

CREATE TABLE IF NOT EXISTS token_burn_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_address TEXT NOT NULL,
    burn_trigger TEXT NOT NULL, -- e.g., 'tx_fee', 'manual', 'scheduled', 'auto_buyback'
    burn_percentage NUMERIC(10, 4) CHECK (burn_percentage >= 0 AND burn_percentage <= 100),
    min_threshold NUMERIC(30, 8) DEFAULT 0, -- minimum amount for burn to activate
    max_cap NUMERIC(30, 8), -- optional maximum total tokens that can be burned
    cooldown_interval INTERVAL, -- optional interval before next burn can occur
    policy_active BOOLEAN DEFAULT TRUE,
    created_by TEXT,
    approved_by TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_token_burn_policy_token ON token_burn_policies(token_address);

COMMENT ON TABLE token_burn_policies IS 'Defines programmable burn rules and thresholds for tokens in Quantora’s economic model.';
-- Table: token_burning_events
-- Description: Records all native or smart contract token burns across the Quantora ecosystem.

CREATE TABLE IF NOT EXISTS token_burning_events (
    burn_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_hash TEXT NOT NULL,
    token_address TEXT NOT NULL, -- Can be native or contract address
    from_address TEXT NOT NULL,
    amount_burned NUMERIC(78, 0) NOT NULL CHECK (amount_burned >= 0),
    burn_reason TEXT, -- Optional context (e.g., 'deflation', 'manual_adjustment', 'penalty')
    initiated_by TEXT NOT NULL, -- user, system, smart_contract
    burn_type TEXT NOT NULL CHECK (burn_type IN ('native', 'erc20', 'erc721', 'erc1155')),
    block_number BIGINT NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_burn_token ON token_burning_events(token_address);
CREATE INDEX IF NOT EXISTS idx_burn_from ON token_burning_events(from_address);
CREATE INDEX IF NOT EXISTS idx_burn_block ON token_burning_events(block_number);

COMMENT ON TABLE token_burning_events IS 'Logs all token burning actions (native or contract-based) with reasons and sources.';
COMMENT ON COLUMN token_burning_events.burn_reason IS 'Describes the motivation behind the burn: deflationary control, malicious penalty, manual adjustment, etc.';
-- Table: zk_circuit_registry
-- Description: Registry of deployed zero-knowledge circuits used across Quantora blockchain

CREATE TABLE IF NOT EXISTS zk_circuit_registry (
    id BIGSERIAL PRIMARY KEY,
    circuit_name TEXT NOT NULL,
    version TEXT NOT NULL,
    circuit_hash TEXT UNIQUE NOT NULL,
    description TEXT,
    purpose TEXT NOT NULL CHECK (purpose IN ('identity_proof', 'scalability', 'privacy', 'compliance', 'data_integrity')),
    proving_key_hash TEXT,
    verification_key_hash TEXT,
    deployment_block_height BIGINT,
    deployment_tx_hash TEXT,
    audit_status TEXT DEFAULT 'pending' CHECK (audit_status IN ('pending', 'audited', 'rejected')),
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_zk_circuit_name_version ON zk_circuit_registry(circuit_name, version);

COMMENT ON TABLE zk_circuit_registry IS 'Tracks all ZK circuits used in Quantora, including versioning and purposes like privacy or scalability.';
