#!/usr/bin/env bash
# ============================================
#   ORION INSTALLER - GITHUB DOWNLOADER
#   Downloads everything from GitHub
#   Author: Ayoub (RDXFGXY1)
#   Version: 2.1
# ============================================
set -euo pipefail

# -------------------------
#  CONFIGURATION
# -------------------------
REPO_URL="https://github.com/RDXFGXY1/Linux-Setup-for-Ex-Windows-Users"
BRANCH="main"
SCRIPT_DIR="Scripts/Orion"

# Local temporary directory
TEMP_DIR="/tmp/orion-install-$(date +%s)"

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
print_header() {
  echo -e "${CYAN}${BOLD}"
  cat << "EOF"
  ╔═══════════════════════════════════════════════╗
  ║                                               ║
  ║           📦  ORION INSTALLER  📦             ║
  ║                                               ║
  ║      Package Update System for Linux          ║
  ║         Downloading from GitHub...            ║
  ║                                               ║
  ╚═══════════════════════════════════════════════╝
EOF
  echo -e "${RESET}"
}

log_info() {
  echo -e "${CYAN}[INFO]${RESET} $*"
}

log_success() {
  echo -e "${GREEN}[✓]${RESET} $*"
}

log_error() {
  echo -e "${RED}[✗]${RESET} $*"
}

check_dependencies() {
  log_info "Checking dependencies..."
  
  if ! command -v git >/dev/null 2>&1; then
    log_error "Git is required but not installed."
    log_info "Install it with your package manager:"
    log_info "  Debian/Ubuntu:  sudo apt install git"
    log_info "  Arch Linux:     sudo pacman -S git"
    log_info "  Fedora:         sudo dnf install git"
    exit 1
  fi
  
  log_success "Git is available"
}

download_from_github() {
  log_info "Downloading Orion from GitHub..."
  
  mkdir -p "$TEMP_DIR"
  
  # Clone only the Orion directory using sparse checkout
  cd "$TEMP_DIR"
  
  if git clone --depth 1 --branch "$BRANCH" --filter=blob:none --sparse "$REPO_URL" . 2>/dev/null; then
    git sparse-checkout init --cone 2>/dev/null || true
    git sparse-checkout set "$SCRIPT_DIR" 2>/dev/null || true
    log_success "Downloaded files from GitHub"
    return 0
  else
    log_error "Failed to download from GitHub"
    return 1
  fi
}

run_installer() {
  local installer_path="$TEMP_DIR/$SCRIPT_DIR/install"
  
  if [ ! -f "$installer_path" ]; then
    log_error "Installer not found in downloaded files"
    return 1
  fi
  
  log_info "Running local installer..."
  chmod +x "$installer_path"
  
  if bash "$installer_path"; then
    log_success "Local installation completed"
    return 0
  else
    log_error "Local installation failed"
    return 1
  fi
}

cleanup() {
  log_info "Cleaning up temporary files..."
  rm -rf "$TEMP_DIR"
  log_success "Cleanup completed"
}

# -------------------------
#  MAIN EXECUTION
# -------------------------
main() {
  print_header
  
  echo -e "${CYAN}Repository: ${BOLD}$REPO_URL${RESET}"
  echo -e "${CYAN}Branch: ${BOLD}$BRANCH${RESET}"
  echo
  
  check_dependencies
  
  # Download from GitHub
  if ! download_from_github; then
    exit 1
  fi
  
  echo
  
  # Run the local installer
  if ! run_installer; then
    log_error "Installation failed"
    cleanup
    exit 1
  fi
  
  cleanup
  
  echo
  echo -e "${GREEN}${BOLD}✓ Orion installation completed successfully!${RESET}"
  echo
  echo -e "${CYAN}Usage:${RESET}"
  echo -e "  ${YELLOW}orion -u discord${RESET}      Update Discord"
  echo -e "  ${YELLOW}orion -u p${RESET}           Update Orion itself"
  echo -e "  ${YELLOW}orion --help${RESET}         Show help"
  echo
}

main "$@"