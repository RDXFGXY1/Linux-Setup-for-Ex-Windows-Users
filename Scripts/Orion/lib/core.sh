#!/usr/bin/env bash
# Core configuration for Orion

# -------------------------
#  CONFIGURATION
# -------------------------
INSTALL_DIR="/usr/local/lib/orion"
MODULES_DIR="$INSTALL_DIR/modules"
LOG_DIR="$INSTALL_DIR/logs"
COMMAND_NAME="orion"

# GitHub update
GITHUB_USER="RDXFGXY1"
GITHUB_REPO="Linux-Setup-for-Ex-Windows-Users"
GITHUB_BRANCH="main"
GITHUB_PATH="Scripts/Orion"

# -------------------------
#  HELPER FUNCTIONS
# -------------------------
log_info() {
    echo -e "${CYAN}[INFO]${RESET} $*"
}

log_success() {
    echo -e "${GREEN}[✓]${RESET} $*"
}

log_warning() {
    echo -e "${YELLOW}[!]${RESET} $*"
}

log_error() {
    echo -e "${RED}[✗]${RESET} $*"
}

# Validate installation
validate_installation() {
    if [ ! -d "$INSTALL_DIR" ]; then
        log_error "Orion is not installed!"
        log_info "Run: bash install/install.sh"
        exit 1
    fi
}
