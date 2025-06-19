#!/bin/bash
# -------------------------------------------------------------------
# restore_core_modules_from_git.sh — Restore original Rust modules
# from Git history if they were deleted or modified accidentally.
# -------------------------------------------------------------------

set -euo pipefail

CORE_DIR="$HOME/Quantora/blockchain/core/src"
cd "$CORE_DIR"

declare -a FILES=(
  "network.rs"
  "validator.rs"
  "mempool.rs"
  "transaction.rs"
  "consensus.rs"
  "state.rs"
  "storage.rs"
  "config.rs"
)

echo "🔍 Attempting to restore original Rust core modules from Git history..."

for FILE in "${FILES[@]}"; do
  echo "[*] Restoring $FILE..."
  if git show HEAD:$FILE > "$FILE" 2>/dev/null; then
    echo "✅ $FILE restored."
  else
    echo "⚠️ $FILE not found in Git history."
  fi
done

echo "🎉 All possible files restored from Git history."

