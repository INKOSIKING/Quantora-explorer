#!/bin/bash
# ============================================================================
# bootstrap_blockchain_core.sh — Ultra Robust Blockchain Core Scaffolder
# Creates essential Rust files/modules to wire up Quantora blockchain system.
# ============================================================================

set -euo pipefail

echo "[🧠] Starting Blockchain Core Scaffolding..."

PROJECT_ROOT="$HOME/Quantora"
BLOCKCHAIN_DIR="$PROJECT_ROOT/blockchain"
CORE_DIR="$BLOCKCHAIN_DIR/core"
API_DIR="$BLOCKCHAIN_DIR/api"
NODE_DIR="$PROJECT_ROOT/quantora-chain/blockchain-node"
GENESIS_JSON="$PROJECT_ROOT/quantora-chain/genesis.json"
GENESIS_MANAGER="$PROJECT_ROOT/tools/genesis_manager.rs"

mkdir -p "$CORE_DIR/src"
mkdir -p "$API_DIR/src"
mkdir -p "$NODE_DIR/src"
mkdir -p "$PROJECT_ROOT/tools"

touch "$NODE_DIR/src/main.rs"
touch "$GENESIS_JSON"
touch "$GENESIS_MANAGER"

for file in network.rs validator.rs mempool.rs transaction.rs consensus.rs state.rs storage.rs config.rs; do
  CORE_FILE="$CORE_DIR/src/$file"
  if [ ! -f "$CORE_FILE" ]; then
    echo "[+] Created: $CORE_FILE"
    touch "$CORE_FILE"
  else
    echo "[✓] Already exists: $CORE_FILE"
  fi
done

echo "✅ Blockchain core modules scaffolded successfully."
echo "📌 Next Steps: Implement logic in:"
echo "   - main.rs for launch logic"
echo "   - core/src/*.rs for mempool, consensus, state, etc."
