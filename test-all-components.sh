
#!/bin/bash

echo "🔍 QUANTORA SYSTEM VERIFICATION TEST"
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

print_info() {
    echo -e "${YELLOW}📋 $1${NC}"
}

# Test 1: Blockchain Node
print_info "Testing Blockchain Node..."
cd blockchain-node
cargo check > /dev/null 2>&1
print_status $? "Blockchain code compiles"

# Test 2: Check if blockchain can start (quick test)
timeout 10s cargo run --release > /dev/null 2>&1 &
BLOCKCHAIN_PID=$!
sleep 5
if kill -0 $BLOCKCHAIN_PID 2>/dev/null; then
    print_status 0 "Blockchain node can start"
    kill $BLOCKCHAIN_PID 2>/dev/null
else
    print_status 1 "Blockchain node failed to start"
fi

cd ..

# Test 3: Explorer
print_info "Testing Explorer..."
if [ -d "explorer" ]; then
    cd explorer
    if [ -f "package.json" ]; then
        npm install > /dev/null 2>&1
        print_status $? "Explorer dependencies installed"
    fi
    cd ..
else
    print_status 1 "Explorer directory not found"
fi

# Test 4: Exchange (if exists)
print_info "Testing Exchange..."
if [ -d "exchange" ]; then
    cd exchange
    if [ -f "package.json" ]; then
        npm install > /dev/null 2>&1
        print_status $? "Exchange dependencies installed"
    fi
    cd ..
else
    print_status 1 "Exchange directory not found"
fi

# Test 5: Security Scanner
print_info "Testing Security Scanner..."
if [ -f "security/code-security-scanner.js" ]; then
    node security/code-security-scanner.js > /dev/null 2>&1
    print_status $? "Security scanner runs without errors"
else
    print_status 1 "Security scanner not found"
fi

# Test 6: Deployment Script
print_info "Testing Deployment Script..."
if [ -f "deploy-all-repos.sh" ]; then
    chmod +x deploy-all-repos.sh
    print_status $? "Deployment script is executable"
else
    print_status 1 "Deployment script not found"
fi

echo ""
echo "🚀 NEXT STEPS:"
echo "1. If blockchain ✅, run: cd blockchain-node && cargo run --release"
echo "2. If explorer ✅, run: cd explorer && npm run dev"
echo "3. If exchange ✅, run: cd exchange && npm run dev"
echo "4. Test APIs with curl or browser"
echo "5. Deploy with: ./deploy-all-repos.sh"
