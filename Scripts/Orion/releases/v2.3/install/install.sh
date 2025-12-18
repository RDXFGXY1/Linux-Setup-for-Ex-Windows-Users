#!/usr/bin/env bash
# ============================================
#   ORION LOCAL INSTALLER
#   Installs Orion from local files
#   Author: Ayoub (RDXFGXY1)
#   Version: 2.2
# ============================================
set -euo pipefail

# -------------------------
#  CONFIGURATION
# -------------------------
INSTALL_DIR="/usr/local/lib/orion"
BIN_DIR="/usr/local/bin"
COMMAND_NAME="orion"
MODULES_DIR="modules"

# Current script directory (now in install/ directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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
  ║        📦  ORION SETUP  📦                   ║
  ║                                               ║
  ║      Package Update System for Linux          ║
  ║         Local Installation                    ║
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
    log_info "Looking in: $SCRIPT_DIR"
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
  
  # Install all module files
  find "$src_dir" -type f | while read -r module; do
    local module_name=$(basename "$module")
    local module_dest="$dest_dir/update-$module_name"
    
    sudo cp "$module" "$module_dest"
    sudo chmod +x "$module_dest"
    
    # Extract version if present
    local version
    version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$module" 2>/dev/null || echo "unknown")
    
    log_success "Installed: $module_name (v$version)"
    count=$((count + 1))
  done
  
  if [ $count -eq 0 ]; then
    log_warning "No modules found in $src_dir"
  else
    log_success "Installed $count module(s)"
  fi
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

install_uninstaller() {
  log_info "Installing uninstaller..."
  
  local src_file="$SCRIPT_DIR/uninstall.sh"
  local dest_dir="$INSTALL_DIR"
  
  if [ -f "$src_file" ]; then
    sudo cp "$src_file" "$dest_dir/"
    sudo chmod +x "$dest_dir/uninstall.sh"
    log_success "Uninstaller installed at $dest_dir/uninstall.sh"
  else
    log_warning "Uninstaller not found: $src_file"
  fi
}

verify_installation() {
  log_info "Verifying installation..."
  
  local errors=0
  
  # Check main command
  if [ ! -x "$BIN_DIR/$COMMAND_NAME" ]; then
    log_error "Main command not found or not executable"
    errors=$((errors + 1))
  else
    log_success "Main command verified: $BIN_DIR/$COMMAND_NAME"
  fi
  
  # Check modules
  local module_count
  module_count=$(find "$INSTALL_DIR/$MODULES_DIR" -type f -executable 2>/dev/null | wc -l)
  
  if [ "$module_count" -eq 0 ]; then
    log_warning "No executable modules found"
  else
    log_success "Found $module_count module(s)"
  fi
  
  if [ $errors -eq 0 ]; then
    log_success "Installation verified successfully"
    return 0
  else
    log_error "Verification failed with $errors error(s)"
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
  echo -e "  ${YELLOW}$COMMAND_NAME -a${RESET}                Update all packages"
  echo -e "  ${YELLOW}$COMMAND_NAME --help${RESET}            Show help"
  echo
  
  echo -e "${CYAN}${BOLD}Installation Details:${RESET}"
  echo -e "  Command:        $BIN_DIR/$COMMAND_NAME"
  echo -e "  Modules:        $INSTALL_DIR/$MODULES_DIR/"
  echo -e "  Logs:           $INSTALL_DIR/logs/"
  
  if [ -f "$INSTALL_DIR/uninstall.sh" ]; then
    echo -e "  Uninstaller:    sudo $INSTALL_DIR/uninstall.sh"
  fi
  echo
  
  # List installed modules
  if [ -d "$INSTALL_DIR/$MODULES_DIR" ]; then
    echo -e "${CYAN}${BOLD}Installed Packages:${RESET}"
    for module in "$INSTALL_DIR/$MODULES_DIR"/update-*; do
      if [ -f "$module" ]; then
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
  echo -e "${GREEN}Happy updating! 🚀${RESET}"
  echo
}

# -------------------------
#  MAIN EXECUTION
# -------------------------
main() {
  print_header
  
  echo -e "${CYAN}Installing Orion Package Manager...${RESET}"
  echo
  
  check_root
  check_sudo
  
  create_directories
  echo
  
  if ! install_main_command; then
    log_error "Failed to install main command"
    exit 1
  fi
  
  echo
  
  if ! install_modules; then
    log_warning "Module installation had issues"
  fi
  
  echo
  
  install_uninstaller
  
  echo
  
  setup_logging
  
  echo
  
  if verify_installation; then
    show_success
  else
    log_error "Installation incomplete"
    exit 1
  fi
}

main "$@"