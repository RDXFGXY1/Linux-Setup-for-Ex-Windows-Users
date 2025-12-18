#!/usr/bin/env bash
# ============================================
#   ORION UNINSTALLER
# ============================================
set -euo pipefail

INSTALL_DIR="/usr/local/lib/orion"
BIN_DIR="/usr/local/bin"
COMMAND_NAME="orion"

ESC='\033['
RESET="${ESC}0m"
RED="${ESC}31m"
GREEN="${ESC}32m"
YELLOW="${ESC}33m"

echo -e "${YELLOW}Uninstalling Orion...${RESET}"
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root/sudo${RESET}"
    echo "Usage: sudo $0"
    exit 1
fi

echo -e "${YELLOW}The following will be removed:${RESET}"
echo "  $BIN_DIR/$COMMAND_NAME"
echo "  $INSTALL_DIR"
echo
echo -e "${YELLOW}Are you sure? [y/N] ${RESET}"
read -r confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Uninstallation cancelled${RESET}"
    exit 0
fi

# Remove files
echo "Removing Orion..."
rm -f "$BIN_DIR/$COMMAND_NAME"
rm -rf "$INSTALL_DIR"

echo -e "${GREEN}Orion has been uninstalled successfully${RESET}"
