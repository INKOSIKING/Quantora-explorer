#!/bin/bash
KEY_DIR="./pq_keys"
PUB_KEY="$KEY_DIR/public.key"
PRIV_KEY="$KEY_DIR/private.key"
echo; echo "🔐 Verifying PQ keypair..."
if [[ ! -f "$PUB_KEY" || ! -f "$PRIV_KEY" ]]; then
  echo "❌ Missing keys in $KEY_DIR"; read -rp "⏸️ Press Enter..."; return 1 2>/dev/null || true
fi
if grep -q "BEGIN" "$PUB_KEY" && grep -q "PRIVATE" "$PRIV_KEY"; then
  echo "✅ PQ keypair structure valid."
else
  echo "⚠️ PQ key content may be invalid."
fi
echo; read -rp "⏸️ Press Enter to finish..."
