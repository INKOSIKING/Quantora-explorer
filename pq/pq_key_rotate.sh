#!/bin/bash
KEYS_DIR="pq_keys"
VALIDATOR_ID=${1:-"validator_default"}
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PUB_KEY="$KEYS_DIR/$VALIDATOR_ID.pub"
PRIV_KEY="$KEYS_DIR/$VALIDATOR_ID.priv"
echo; echo "🔁 Rotating PQ keypair for $VALIDATOR_ID"
mkdir -p "$KEYS_DIR"
[[ -f "$PUB_KEY" ]] && mv "$PUB_KEY" "$PUB_KEY.bak_$TIMESTAMP"
[[ -f "$PRIV_KEY" ]] && mv "$PRIV_KEY" "$PRIV_KEY.bak_$TIMESTAMP"
echo "PQ_PUBLIC_KEY_${RANDOM}${RANDOM}" > "$PUB_KEY"
echo "PQ_PRIVATE_KEY_${RANDOM}${RANDOM}" > "$PRIV_KEY"
echo "✅ New keys generated."
echo; read -rp "⏸️ Press Enter to finish..."
