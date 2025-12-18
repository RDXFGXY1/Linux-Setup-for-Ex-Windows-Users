#!/usr/bin/env bash
# Orion rollback action handler

show_rollback_help() {
    cat << EOF
${CYAN}${BOLD}Orion Rollback Commands${RESET}

${CYAN}Usage:${RESET}
  orion rollback [OPTION] [BACKUP_ID]

${CYAN}Options:${RESET}
  -l, --list        List available backups
  -b, --backup      Create new backup
  -r, --restore ID  Restore from backup
  -f, --force       Force restore without confirmation
  -c, --clean       Clean up old backups
  -h, --help        Show this help

${CYAN}Examples:${RESET}
  orion rollback --list           List all backups
  orion rollback --backup         Create a new backup
  orion rollback orion_20241215-143022  Restore specific backup
  orion rollback --restore latest Restore latest backup
  orion rollback --clean          Clean up old backups
EOF
}

rollback_action() {
    local action=""
    local target=""
    local force="false"
    
    # Parse rollback subcommands
    while [[ $# -gt 0 ]]; do
        case $1 in
            -l|--list)
                action="list"
                shift
                ;;
            -b|--backup)
                action="backup"
                shift
                ;;
            -r|--restore)
                if [ -n "${2:-}" ]; then
                    action="restore"
                    target="$2"
                    shift 2
                else
                    log_error "Backup ID required for --restore"
                    show_rollback_help
                    return 1
                fi
                ;;
            -f|--force)
                force="true"
                shift
                ;;
            -c|--clean)
                action="clean"
                shift
                ;;
            -h|--help)
                show_rollback_help
                return 0
                ;;
            *)
                # If it's not an option, assume it's a backup ID
                if [ -z "$action" ]; then
                    action="restore"
                    target="$1"
                    shift
                else
                    log_error "Unknown argument: $1"
                    show_rollback_help
                    return 1
                fi
                ;;
        esac
    done
    
    # Initialize rollback system
    init_rollback_system
    
    # Default action if none specified
    if [ -z "$action" ]; then
        show_rollback_help
        return 0
    fi
    
    # Execute action
    case $action in
        list)
            list_backups
            ;;
        backup)
            log_info "Creating Orion backup..."
            backup_orion
            ;;
        restore)
            if [ "$target" = "latest" ]; then
                target=$(get_latest_backup)
                if [ -z "$target" ]; then
                    log_error "No backups found"
                    return 1
                fi
            fi
            
            if [ "$force" != "true" ]; then
                echo -e "${YELLOW}Restore Orion from backup: $target? [y/N] ${RESET}"
                read -r confirm
                if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                    log_info "Restore cancelled"
                    return 0
                fi
            fi
            
            restore_orion "$target"
            ;;
        clean)
            log_info "Cleaning up old backups..."
            cleanup_old_backups
            log_success "Cleanup completed"
            ;;
    esac
}
