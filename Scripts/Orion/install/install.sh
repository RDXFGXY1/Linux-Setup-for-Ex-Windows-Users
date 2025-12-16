#!/usr/bin/env bash
# ============================================
#   ORION LOCAL INSTALLER
#   Installs Orion from local files
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
MODULES_DIR="modules"

# Current script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

create_directories() {
  log_info "Creating directories..."
  
  sudo mkdir -p "$INSTALL_DIR/$MODULES_DIR"
  sudo mkdir -p "$INSTALL_DIR/logs"
  
  log_success "Directories created at $INSTALL_DIR"
}

install_main_command() {
  log_info "Installing main command..."
  
  local src_file="$SCRIPT_DIR/orion"
  local dest_file="$BIN_DIR/$COMMAND_NAME"
  
  if [ ! -f "$src_file" ]; then
    log_error "Main command file not found: $src_file"
    return 1
  fi
  
  sudo cp "$src_file" "$dest_file"
  sudo chmod +x "$dest_file"
  
  log_success "Main command installed: $COMMAND_NAME"
  return 0
}

install_modules() {
  log_info "Installing modules..."
  
  local src_dir="$SCRIPT_DIR/$MODULES_DIR"
  local dest_dir="$INSTALL_DIR/$MODULES_DIR"
  
  if [ ! -d "$src_dir" ]; then
    log_error "Modules directory not found: $src_dir"
    return 1
  fi
  
  local count=0
  
  for module in "$src_dir"/*; do
    if [ -f "$module" ] && [ -x "$module" ] || [[ "$module" =~ \.(sh|bash)$ ]]; then
      local module_name=$(basename "$module")
      sudo cp "$module" "$dest_dir/"
      sudo chmod +x "$dest_dir/$module_name"
      
      # Extract version if present
      local version
      version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$module" 2>/dev/null || echo "unknown")
      
      log_success "Installed: $module_name (v$version)"
      count=$((count + 1))
    fi
  done
  
  log_success "Installed $count module(s)"
  return 0
}

setup_logging() {
  log_info "Setting up logging..."
  
  local log_dir="$INSTALL_DIR/logs"
  local user_id=$(id -u)
  local group_id=$(id -g)
  
  sudo chown -R "$user_id:$group_id" "$log_dir"
  sudo chmod 755 "$log_dir"
  
  log_success "Logging setup completed"
}

verify_installation() {
  log_info "Verifying installation..."
  
  local errors=0
  
  # Check main command
  if [ ! -x "$BIN_DIR/$COMMAND_NAME" ]; then
    log_error "Main command not found or not executable"
    errors=$((errors + 1))
  fi
  
  # Check modules
  local module_count
  module_count=$(find "$INSTALL_DIR/$MODULES_DIR" -type f -executable 2>/dev/null | wc -l)
  
  if [ "$module_count" -eq 0 ]; then
    log_warning "No modules found"
  else
    log_success "Found $module_count module(s)"
  fi
  
  if [ $errors -eq 0 ]; then
    log_success "Installation verified"
    return 0
  else
    log_error "Verification failed with $errors error(s)"
    return 1
  fi
}

# -------------------------
#  MAIN EXECUTION
# -------------------------
main() {
  echo
  log_info "Starting Orion installation..."
  echo
  
  check_root
  check_sudo
  
  create_directories
  echo
  
  if ! install_main_command; then
    exit 1
  fi
  
  echo
  
  if ! install_modules; then
    log_warning "Module installation had issues"
  fi
  
  echo
  
  setup_logging
  
  echo
  
  if verify_installation; then
    log_success "Orion installation completed successfully!"
    
    echo
    echo -e "${CYAN}${BOLD}Installation Summary:${RESET}"
    echo -e "  Command:  $BIN_DIR/$COMMAND_NAME"
    echo -e "  Modules:  $INSTALL_DIR/$MODULES_DIR/"
    echo -e "  Logs:     $INSTALL_DIR/logs/"
    echo
  else
    log_error "Installation incomplete"
    exit 1
  fi
}

main "$@"