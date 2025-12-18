#!/usr/bin/env bash
# ============================================
#   ORION - Package Update Manager
#   Author: Ayoub (RDXFGXY1)
#   Version: 2.4
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
#  LOAD LIBRARIES
# -------------------------
source "$INSTALL_DIR/lib/core.sh"
source "$INSTALL_DIR/lib/colors.sh"
source "$INSTALL_DIR/lib/version_check.sh"
source "$INSTALL_DIR/lib/utils.sh"
source "$INSTALL_DIR/lib/rollback.sh"

# Load action handlers
source "$INSTALL_DIR/actions/help.sh"
source "$INSTALL_DIR/actions/list.sh"
source "$INSTALL_DIR/actions/update.sh"
source "$INSTALL_DIR/actions/update_all.sh"
source "$INSTALL_DIR/actions/self_update.sh"
source "$INSTALL_DIR/actions/rollback.sh"

# -------------------------
#  MAIN EXECUTION
# -------------------------
main() {
    local action=""
    local package=""
    local bypass="false"
    local tarball_mode="false"
    
    # Check for special rollback command
    if [ "${1:-}" = "rollback" ] || [ "${1:-}" = "--rollback" ]; then
        shift
        rollback_action "$@"
        exit $?
    fi
    
    # Parse regular arguments
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