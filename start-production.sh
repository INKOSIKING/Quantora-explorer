
#!/bin/bash

echo "🚀 Starting Quantora Production Environment"
echo "=========================================="

# Kill any existing processes
pkill -f "cargo run"
pkill -f "node"
pkill -f "npm"

# Start blockchain node in background
echo "Starting blockchain node..."
cd blockchain-node
nohup cargo run --release > ../logs/blockchain.log 2>&1 &
BLOCKCHAIN_PID=$!
echo "Blockchain PID: $BLOCKCHAIN_PID"
cd ..

# Wait for blockchain to start
sleep 10

# Start explorer if exists
if [ -d "explorer" ]; then
    echo "Starting explorer..."
    cd explorer
    nohup npm run start > ../logs/explorer.log 2>&1 &
    EXPLORER_PID=$!
    echo "Explorer PID: $EXPLORER_PID"
    cd ..
fi

# Start exchange if exists
if [ -d "exchange" ]; then
    echo "Starting exchange..."
    cd exchange
    nohup npm run start > ../logs/exchange.log 2>&1 &
    EXCHANGE_PID=$!
    echo "Exchange PID: $EXCHANGE_PID"
    cd ..
fi

echo ""
echo "✅ All services started!"
echo "📊 Check logs in ./logs/ directory"
echo "🌐 Access points:"
echo "   - Blockchain RPC: http://0.0.0.0:8545"
echo "   - Explorer: http://0.0.0.0:3000"
echo "   - Exchange: http://0.0.0.0:5000"
echo ""
echo "To stop all services: pkill -f 'cargo run' && pkill -f 'node'"
