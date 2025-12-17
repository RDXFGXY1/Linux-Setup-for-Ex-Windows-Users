#!/usr/bin/env bash
# ============================================
#   ORION - Package Update Manager
#   Author: Ayoub (RDXFGXY1)
#   Version: 2.3
# ============================================
set -euo pipefail

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

# -------------------------
#  VERSION CHECK FUNCTION
# -------------------------
check_for_updates() {
  # Extract current version from this script
  local current_version
  current_version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$0" 2>/dev/null) || return 0
  
  # Check if curl is available
  if ! command -v curl >/dev/null 2>&1; then
    return 0
  fi
  
  # Construct GitHub raw content URL
  local github_url="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}/${GITHUB_PATH}/orion"
  
  # Fetch remote version (first 20 lines only, with timeout)
  local remote_content
  remote_content=$(curl -sL --max-time 3 "$github_url" 2>/dev/null | head -n 20) || return 0
  
  # Parse remote version
  local remote_version
  remote_version=$(echo "$remote_content" | grep -oP '^#\s*Version:\s*\K[\d.]+' 2>/dev/null) || return 0
  
  # Skip if no valid version found
  if [ -z "$remote_version" ] || [ -z "$current_version" ]; then
    return 0
  fi
  
  # Compare versions (using version comparison)
  # Convert versions to comparable format: e.g., "2.3" -> 0203
  local current_comparable
  local remote_comparable
  
  current_comparable=$(echo "$current_version" | awk -F. '{printf "%d%02d", $1, $2}')
  remote_comparable=$(echo "$remote_version" | awk -F. '{printf "%d%02d", $1, $2}')
  
  # Display message only if remote version is newer
  if [ "$remote_comparable" -gt "$current_comparable" ]; then
    log_info "New Orion version available: ${current_version} → ${remote_version}"
    log_info "Update with: orion -s"
  fi
  
  return 0
}

# -------------------------
#  MODULE FUNCTIONS
# -------------------------
list_modules() {
  echo -e "${CYAN}${BOLD}Available packages:${RESET}"
  echo
  
  if [ ! -d "$MODULES_DIR" ]; then
    log_error "No modules directory found"
    return 1
  fi
  
  local count=0
  for module in "$MODULES_DIR"/update-*; do
    if [ -f "$module" ]; then
      local pkg=$(basename "$module" | sed 's/^update-//')
      local version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$module" 2>/dev/null || echo "")
      
      # Get description
      local desc=$(grep -oP '^#\s*Description:\s*\K.*' "$module" 2>/dev/null || echo "No description")
      
      if [ -n "$version" ]; then
        echo -e "  ${GREEN}${pkg}${RESET} ${CYAN}(v$version)${RESET}"
      else
        echo -e "  ${GREEN}${pkg}${RESET}"
      fi
      echo -e "      ${desc}"
      echo
      count=$((count + 1))
    fi
  done
  
  if [ $count -eq 0 ]; then
    log_warning "No modules found"
  else
    echo -e "${CYAN}Total: ${BOLD}$count${RESET} package(s) available"
  fi
}

update_package() {
  local pkg="$1"
  local bypass="$2"
  local tarball_mode="$3"
  local module_file="$MODULES_DIR/update-$pkg"
  local log_file="$LOG_DIR/update-$pkg-$(date +%Y%m%d-%H%M%S).log"
  
  if [ ! -f "$module_file" ]; then
    log_error "Package '$pkg' not found"
    echo
    log_info "Available packages:"
    list_modules
    return 1
  fi
  
  if [ "$bypass" != "true" ]; then
    echo -e "${YELLOW}Update $pkg? [y/N] ${RESET}"
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      log_info "Update cancelled"
      return 0
    fi
  fi
  
  log_info "Updating $pkg..."
  
  # Create log directory if needed
  mkdir -p "$LOG_DIR"
  
  # Execute module with logging and export tarball flag if set
  if [ "$tarball_mode" = "true" ]; then
    export ORION_FORCE_TARBALL="true"
  fi
  
  if bash "$module_file" 2>&1 | tee "$log_file"; then
    log_success "$pkg updated successfully"
    log_info "Log saved: $log_file"
    return 0
  else
    log_error "Failed to update $pkg"
    log_info "Check log: $log_file"
    return 1
  fi
}

update_all_packages() {
  local bypass="$1"
  local updated=0
  local failed=0
  
  echo -e "${CYAN}${BOLD}Updating all packages...${RESET}"
  echo
  
  if [ "$bypass" != "true" ]; then
    echo -e "${YELLOW}Update ALL packages? [y/N] ${RESET}"
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      log_info "Update cancelled"
      return 0
    fi
  fi
  
  for module in "$MODULES_DIR"/update-*; do
    if [ -f "$module" ]; then
      local pkg=$(basename "$module" | sed 's/^update-//')
      
      echo -e "${CYAN}=== Updating: $pkg ===${RESET}"
      if update_package "$pkg" "true" "false"; then
        updated=$((updated + 1))
      else
        failed=$((failed + 1))
      fi
      echo
    fi
  done
  
  echo -e "${CYAN}${BOLD}Update Summary:${RESET}"
  echo -e "  ${GREEN}Successfully updated: $updated${RESET}"
  if [ $failed -gt 0 ]; then
    echo -e "  ${RED}Failed: $failed${RESET}"
  fi
}

# Get list of module files from GitHub
get_github_modules_list() {
  local api_url="https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/contents/${GITHUB_PATH}/modules?ref=${GITHUB_BRANCH}"
  
  # Try with jq if available
  if command -v jq >/dev/null 2>&1; then
    curl -sL "$api_url" 2>/dev/null | jq -r '.[].name' 2>/dev/null
  else
    # Fallback: parse JSON manually
    curl -sL "$api_url" 2>/dev/null | grep -oP '"name":\s*"\K[^"]+' 2>/dev/null
  fi
}

update_orion_self() {
  log_info "Updating Orion from GitHub..."
  
  local temp_dir="/tmp/orion-update-$(date +%s)"
  mkdir -p "$temp_dir/modules"
  
  # Download main orion script
  log_info "Downloading main Orion script..."
  local orion_url="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$GITHUB_BRANCH/$GITHUB_PATH/orion"
  
  if curl -fsSL "$orion_url" -o "$temp_dir/orion" 2>/dev/null; then
    log_success "Downloaded main script"
  else
    log_error "Failed to download main script"
    rm -rf "$temp_dir"
    return 1
  fi
  
  # Get list of all modules from GitHub
  log_info "Fetching module list from GitHub..."
  local modules_list
  modules_list=$(get_github_modules_list)
  
  if [ -z "$modules_list" ]; then
    log_warning "Could not fetch module list, trying known modules..."
    # Fallback to known modules if API fails
    modules_list="discord
vscode"
  fi
  
  # Download all modules
  log_info "Downloading modules..."
  local downloaded=0
  local failed=0
  
  while IFS= read -r module_name; do
    [ -z "$module_name" ] && continue
    
    local module_url="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$GITHUB_BRANCH/$GITHUB_PATH/modules/$module_name"
    local dest="$temp_dir/modules/$module_name"
    
    if curl -fsSL "$module_url" -o "$dest" 2>/dev/null; then
      local version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$dest" 2>/dev/null || echo "unknown")
      log_success "Downloaded: $module_name (v$version)"
      downloaded=$((downloaded + 1))
    else
      log_warning "Failed to download: $module_name"
      failed=$((failed + 1))
    fi
  done <<< "$modules_list"
  
  if [ $downloaded -eq 0 ]; then
    log_error "Failed to download any modules from GitHub"
    rm -rf "$temp_dir"
    return 1
  fi
  
  echo
  log_success "Downloaded $downloaded module(s) from GitHub"
  
  # Update main command
  log_info "Installing main command..."
  if [ -f "$temp_dir/orion" ]; then
    sudo cp "$temp_dir/orion" "$(which orion)" 2>/dev/null || sudo cp "$temp_dir/orion" "/usr/local/bin/orion"
    sudo chmod +x "$(which orion 2>/dev/null || echo "/usr/local/bin/orion")"
    log_success "Main command updated"
  fi
  
  # Update modules
  log_info "Installing modules..."
  for module in "$temp_dir/modules"/*; do
    if [ -f "$module" ]; then
      local module_name=$(basename "$module")
      local module_dest="$MODULES_DIR/update-$module_name"
      
      # Create modules directory if it doesn't exist
      sudo mkdir -p "$MODULES_DIR"
      
      sudo cp "$module" "$module_dest"
      sudo chmod +x "$module_dest"
      
      local version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$module" 2>/dev/null || echo "unknown")
      log_success "Installed: $module_name (v$version)"
    fi
  done
  
  # Cleanup
  rm -rf "$temp_dir"
  
  echo
  log_success "Orion updated successfully!"
  echo
  log_info "Run 'orion -l' to see all modules"
}

show_help() {
  cat << EOF
${CYAN}${BOLD}Orion - Package Update Manager${RESET}
Version: 2.3

${CYAN}Usage:${RESET}
  orion [OPTION] [PACKAGE]

${CYAN}Options:${RESET}
  -l, --list              List available packages
  -u, --update PACKAGE    Update specific package
  -a, --all               Update all packages
  -y, --yes               Bypass confirmation prompts
  -t, --tarball           Force tarball installation (bypass package managers)
  -s, --self              Update Orion itself from GitHub
  -h, --help              Show this help message
  -v, --version           Show version

${CYAN}Examples:${RESET}
  orion -l                 List all packages
  orion -u discord         Update Discord
  orion -u discord -y      Update Discord without confirmation
  orion -u discord -t      Update Discord using tarball method
  orion -u discord -t -y   Update Discord via tarball without confirmation
  orion -a                 Update all packages (with confirmation)
  orion -a -y              Update all packages (no confirmation)
  orion -s                 Update Orion from GitHub

${CYAN}Module Directory:${RESET}
  $MODULES_DIR

${CYAN}Log Directory:${RESET}
  $LOG_DIR
EOF
}

show_version() {
  echo "Orion Package Manager v2.3"
  echo "Installation: $INSTALL_DIR"
  echo "Modules: $(find "$MODULES_DIR" -name 'update-*' 2>/dev/null | wc -l)"
}

# -------------------------
#  MAIN EXECUTION
# -------------------------
main() {
  local action=""
  local package=""
  local bypass="false"
  local tarball_mode="false"
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -l|--list)
        action="list"
        shift
        ;;
      -u|--update)
        if [ -n "${2:-}" ]; then
          action="update"
          package="$2"
          shift 2
        else
          log_error "Package name required for -u option"
          echo
          show_help
          exit 1
        fi
        ;;
      -a|--all)
        action="all"
        shift
        ;;
      -y|--yes)
        bypass="true"
        shift
        ;;
      -t|--tarball)
        tarball_mode="true"
        shift
        ;;
      -s|--self)
        action="self"
        shift
        ;;
      -h|--help)
        show_help
        exit 0
        ;;
      -v|--version)
        show_version
        exit 0
        ;;
      *)
        log_error "Unknown option: $1"
        echo
        show_help
        exit 1
        ;;
    esac
  done
  
  # Check for updates (non-blocking, runs in background)
  check_for_updates 2>/dev/null || true &
  
  # Default action if none specified
  if [ -z "$action" ]; then
    show_help
    exit 0
  fi
  
  # Execute action
  case $action in
    list)
      list_modules
      ;;
    update)
      update_package "$package" "$bypass" "$tarball_mode"
      ;;
    all)
      update_all_packages "$bypass"
      ;;
    self)
      update_orion_self
      ;;
  esac
}

main "$@"
