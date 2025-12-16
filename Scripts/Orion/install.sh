#!/usr/bin/env bash
# ============================================
#   orion INSTALLER - GITHUB SYNC ONLY
#   Downloads everything from GitHub
#   Author: Ayoub (RDXFGXY1)
#   Version: 2.0
# ============================================
set -euo pipefail

# -------------------------
#  CONFIGURATION
# -------------------------
INSTALL_DIR="/usr/local/lib/orion"
BIN_DIR="/usr/local/bin"
COMMAND_NAME="orion"

# GitHub repository details
GITHUB_USER="RDXFGXY1"
GITHUB_REPO="Linux-Setup-for-Ex-Windows-Users"
GITHUB_BRANCH="main"
BASE_PATH="Scripts"

# GitHub URLs
GITHUB_API="https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/contents"
GITHUB_RAW="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}"

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
BLUE="${ESC}34m"

# -------------------------
#  HELPER FUNCTIONS
# -------------------------
print_header() {
  clear
  echo -e "${CYAN}${BOLD}"
  cat << "EOF"
  ╔═══════════════════════════════════════════════╗
  ║                                               ║
  ║           📦  orion INSTALLER  📦            ║
  ║                                               ║
  ║      Package Update System for Linux         ║
  ║         Everything from GitHub!              ║
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

log_warning() {
  echo -e "${YELLOW}[!]${RESET} $*"
}

log_error() {
  echo -e "${RED}[✗]${RESET} $*"
}

check_root() {
  if [ "$EUID" -eq 0 ]; then
    log_error "Please do not run this script as root!"
    log_info "Run it as a normal user. It will ask for sudo when needed."
    exit 1
  fi
}

check_sudo() {
  log_info "Checking sudo privileges..."
  if ! sudo -v; then
    log_error "This script requires sudo privileges to install."
    exit 1
  fi
  log_success "Sudo access confirmed"
}

check_dependencies() {
  log_info "Checking dependencies..."
  
  local missing=()
  
  if ! command -v curl >/dev/null 2>&1; then
    missing+=("curl")
  fi
  
  if ! command -v tar >/dev/null 2>&1; then
    missing+=("tar")
  fi
  
  if [ ${#missing[@]} -gt 0 ]; then
    log_error "Missing required tools: ${missing[*]}"
    echo
    log_info "Install them with your package manager:"
    log_info "  Debian/Ubuntu:  sudo apt install ${missing[*]}"
    log_info "  Arch Linux:     sudo pacman -S ${missing[*]}"
    log_info "  Fedora:         sudo dnf install ${missing[*]}"
    exit 1
  fi
  
  log_success "All dependencies satisfied"
}

create_directories() {
  log_info "Creating directories..."
  
  sudo mkdir -p "$INSTALL_DIR/modules"
  sudo mkdir -p "$INSTALL_DIR/logs"
  
  log_success "Directories created at $INSTALL_DIR"
}

# -------------------------
#  GITHUB FILE OPERATIONS
# -------------------------

# Get list of files from a GitHub directory
get_file_list() {
  local path="$1"
  local api_url="${GITHUB_API}/${path}?ref=${GITHUB_BRANCH}"
  
  local response
  response=$(curl -sL "$api_url" 2>/dev/null)
  
  if [ -z "$response" ]; then
    return 1
  fi
  
  # Parse file names (works with or without jq)
  if command -v jq >/dev/null 2>&1; then
    echo "$response" | jq -r '.[] | select(.type=="file") | .name'
  else
    echo "$response" | grep -oP '"name":\s*"\K[^"]+' | grep -v '^\.git'
  fi
}

# Download a file from GitHub
download_file() {
  local remote_path="$1"
  local local_path="$2"
  local file_url="${GITHUB_RAW}/${remote_path}"
  
  if sudo curl -fsSL "$file_url" -o "$local_path" 2>/dev/null; then
    return 0
  else
    return 1
  fi
}

# -------------------------
#  MAIN INSTALLATION
# -------------------------

install_main_command() {
  log_info "Installing main orion command..."
  
  local remote_file="${BASE_PATH}/orion"
  local local_file="$BIN_DIR/$COMMAND_NAME"
  
  if download_file "$remote_file" "$local_file"; then
    sudo chmod +x "$local_file"
    log_success "Main command installed: $COMMAND_NAME"
    return 0
  else
    log_error "Failed to download main command from GitHub"
    log_info "Expected file: ${GITHUB_RAW}/${remote_file}"
    return 1
  fi
}

install_modules() {
  log_info "Installing modules from GitHub..."
  echo
  
  local modules_path="${BASE_PATH}/modules"
  local modules
  
  modules=$(get_file_list "$modules_path")
  
  if [ -z "$modules" ]; then
    log_error "No modules found in GitHub repository"
    log_info "Path: $modules_path"
    return 1
  fi
  
  local success_count=0
  local fail_count=0
  
  while IFS= read -r module; do
    [ -z "$module" ] && continue
    
    local remote_file="${modules_path}/${module}"
    local local_file="$INSTALL_DIR/modules/$module"
    
    log_info "Downloading: $module"
    
    if download_file "$remote_file" "$local_file"; then
      sudo chmod +x "$local_file"
      
      # Extract version if present
      local version
      version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$local_file" 2>/dev/null || echo "unknown")
      
      log_success "Installed: $module (v$version)"
      success_count=$((success_count + 1))
    else
      log_error "Failed: $module"
      fail_count=$((fail_count + 1))
    fi
  done <<< "$modules"
  
  echo
  log_success "Installed $success_count module(s)"
  if [ $fail_count -gt 0 ]; then
    log_warning "$fail_count module(s) failed"
  fi
  
  return 0
}

verify_installation() {
  log_info "Verifying installation..."
  
  local errors=0
  
  # Check main command
  if [ ! -x "$BIN_DIR/$COMMAND_NAME" ]; then
    log_error "Main command not found or not executable"
    errors=$((errors + 1))
  fi
  
  # Check module directory
  if [ ! -d "$INSTALL_DIR/modules" ]; then
    log_error "Module directory not found"
    errors=$((errors + 1))
  fi
  
  # Check if at least one module exists
  local module_count
  module_count=$(find "$INSTALL_DIR/modules" -type f -executable 2>/dev/null | wc -l)
  
  if [ "$module_count" -eq 0 ]; then
    log_warning "No executable modules found"
  fi
  
  if [ $errors -eq 0 ]; then
    log_success "Installation verified successfully"
    return 0
  else
    log_error "Installation verification failed with $errors error(s)"
    return 1
  fi
}

show_success() {
  echo
  echo -e "${GREEN}${BOLD}╔═══════════════════════════════════════════════╗${RESET}"
  echo -e "${GREEN}${BOLD}║                                               ║${RESET}"
  echo -e "${GREEN}${BOLD}║        ✓ Installation Complete! ✓            ║${RESET}"
  echo -e "${GREEN}${BOLD}║                                               ║${RESET}"
  echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════╝${RESET}"
  echo
  echo -e "${CYAN}${BOLD}Command installed:${RESET} $COMMAND_NAME"
  echo
  echo -e "${CYAN}${BOLD}Quick Start:${RESET}"
  echo -e "  ${YELLOW}$COMMAND_NAME -l${RESET}                List available packages"
  echo -e "  ${YELLOW}$COMMAND_NAME -u discord${RESET}        Update Discord"
  echo -e "  ${YELLOW}$COMMAND_NAME --help${RESET}            Show help"
  echo
  echo -e "${CYAN}${BOLD}Installation Details:${RESET}"
  echo -e "  Command:        $BIN_DIR/$COMMAND_NAME"
  echo -e "  Modules:        $INSTALL_DIR/modules/"
  echo -e "  Logs:           $INSTALL_DIR/logs/"
  echo
  echo -e "${CYAN}${BOLD}What's Installed:${RESET}"
  
  # List installed modules
  if [ -d "$INSTALL_DIR/modules" ]; then
    for module in "$INSTALL_DIR/modules"/update-*; do
      if [ -x "$module" ]; then
        local pkg=$(basename "$module" | sed 's/^update-//')
        local version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$module" 2>/dev/null || echo "")
        if [ -n "$version" ]; then
          echo -e "  ${GREEN}✓${RESET} $pkg ${CYAN}(v$version)${RESET}"
        else
          echo -e "  ${GREEN}✓${RESET} $pkg"
        fi
      fi
    done
  fi
  
  echo
  echo -e "${CYAN}${BOLD}To Update:${RESET}"
  echo -e "  Run this installer again to sync latest modules from GitHub"
  echo
  echo -e "${GREEN}Happy updating! 🚀${RESET}"
  echo
}

# -------------------------
#  MAIN EXECUTION
# -------------------------
main() {
  print_header
  
  echo -e "${CYAN}This installer downloads orion from GitHub.${RESET}"
  echo -e "${CYAN}Repository: ${BOLD}${GITHUB_USER}/${GITHUB_REPO}${RESET}"
  echo -e "${CYAN}Command name: ${BOLD}$COMMAND_NAME${RESET}"
  echo
  
  # Checks
  check_root
  check_sudo
  check_dependencies
  
  echo
  log_info "Starting installation from GitHub..."
  echo
  
  # Create directories
  create_directories
  
  # Download and install main command
  if ! install_main_command; then
    log_error "Failed to install main command"
    log_info "Make sure the file exists at:"
    log_info "  ${GITHUB_RAW}/${BASE_PATH}/orion"
    exit 1
  fi
  
  echo
  
  # Download and install modules
  if ! install_modules; then
    log_warning "Some modules failed to install"
  fi
  
  echo
  
  # Verify
  if verify_installation; then
    show_success
  else
    echo
    log_error "Installation incomplete. Please check the errors above."
    exit 1
  fi
}

# -------------------------
#  ENTRY POINT
# -------------------------
main "$@"