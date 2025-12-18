#!/usr/bin/env bash
# Update all packages action

update_all_packages() {
    local bypass="$1"
    local updated=0
    local failed=0
    
    validate_installation
    
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
