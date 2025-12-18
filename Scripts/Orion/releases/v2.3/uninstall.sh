#!/usr/bin/env bash
# ============================================
#   ORION UNINSTALLER
#   Removes Orion completely
#   Author: Ayoub (RDXFGXY1)
#   Version: 2.1
# ============================================
set -euo pipefail

# -------------------------
#  CONFIGURATION
# -------------------------
INSTALL_DIR="/usr/local/lib/orion"
BIN_DIR="/usr/local/bin"
COMMAND_NAME="orion"

# -------------------------
#  COLORS
# -------------------------
ESC='\033['
RESET="${ESC}0m"
BOLD="${ESC}1m"
RED="${ESC}31m"
GREEN="${ESC}32m"
YELLOW="${ESC}33m"
CYAN="${ESC}36m"

# -------------------------
#  HELPER FUNCTIONS
# -------------------------
log_info() {
  echo -e "${CYAN}[INFO]${RESET} $*"
}

log_success() {
  echo -e "${GREEN}[✓]${RESET} $*"
}

log_error() {
  echo -e "${RED}[✗]${RESET} $*"
}

check_root() {
  if [ "$EUID" -ne 0 ]; then
    log_error "This script must be run as root for complete uninstallation"
    log_info "Use: sudo bash $0"
    exit 1
  fi
}

confirm_uninstall() {
  echo -e "${YELLOW}${BOLD}⚠️  WARNING: This will completely remove Orion!${RESET}"
  echo
  echo -e "${CYAN}The following will be removed:${RESET}"
  echo -e "  Command: $BIN_DIR/$COMMAND_NAME"
  echo -e "  Directory: $INSTALL_DIR"
  echo -e "  All modules and logs"
  echo

  # Auto-confirm if ORION_YES is set
  if [[ "${ORION_YES}" == "1" ]]; then
    echo -e "${YELLOW}Auto-confirm enabled (ORION_YES=1)${RESET}"
    confirm="y"
  else
    echo -e "${YELLOW}Are you sure? [y/N] ${RESET}"
    read -r confirm
  fi

  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_info "Uninstallation cancelled"
    exit 0
  fi
}

remove_files() {
  log_info "Removing files..."
  
  # Remove main command
  if [ -f "$BIN_DIR/$COMMAND_NAME" ]; then
    rm -f "$BIN_DIR/$COMMAND_NAME"
    log_success "Removed: $BIN_DIR/$COMMAND_NAME"
  fi
  
  # Remove installation directory
  if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    log_success "Removed: $INSTALL_DIR"
  else
    log_warning "Installation directory not found: $INSTALL_DIR"
  fi
}

# -------------------------
#  MAIN EXECUTION
# -------------------------
main() {
  echo
  echo -e "${CYAN}${BOLD}Orion Uninstaller${RESET}"
  echo
  
  check_root
  confirm_uninstall
  
  echo
  
  remove_files
  
  echo
  log_success "Orion has been completely uninstalled!"
  echo
}

main "$@"
