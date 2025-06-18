#!/bin/bash
KEYS_DIR="pq_keys"
mkdir -p "$KEYS_DIR"
WALLET_NAME=${1:-"wallet_$(date +%s)"}
PUB_KEY_FILE="$KEYS_DIR/$WALLET_NAME.pub"
PRIV_KEY_FILE="$KEYS_DIR/$WALLET_NAME.priv"
echo; echo "🔐 Generating PQ-stub keypair for wallet: $WALLET_NAME"
echo "PQ_PUBLIC_KEY_$RANDOM$RANDOM" > "$PUB_KEY_FILE"
echo "PQ_PRIVATE_KEY_$RANDOM$RANDOM" > "$PRIV_KEY_FILE"
echo "✅ Keys generated:"
echo "   🔓 $PUB_KEY_FILE"
echo "   🔐 $PRIV_KEY_FILE"
echo; read -rp "⏸️ Press Enter to finish..."
