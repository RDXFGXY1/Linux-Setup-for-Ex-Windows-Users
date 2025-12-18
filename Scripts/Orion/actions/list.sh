#!/usr/bin/env bash
# List modules action

list_modules() {
    validate_installation
    
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
            local version=$(get_package_version "$pkg")
            local desc=$(get_package_description "$pkg")
            
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
