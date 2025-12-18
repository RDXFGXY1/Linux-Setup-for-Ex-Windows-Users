#!/usr/bin/env bash
# Self update action

update_orion_self() {
    log_info "Updating Orion from GitHub..."
    
    local temp_dir="/tmp/orion-update-$(date +%s)"
    mkdir -p "$temp_dir/modules"
    
    # Download main orion script
    log_info "Downloading main Orion script..."
    local orion_url="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$GITHUB_BRANCH/$GITHUB_PATH/orion.sh"
    
    if curl -fsSL "$orion_url" -o "$temp_dir/orion.sh" 2>/dev/null; then
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
    if [ -f "$temp_dir/orion.sh" ]; then
        sudo cp "$temp_dir/orion.sh" "$(which orion)" 2>/dev/null || sudo cp "$temp_dir/orion.sh" "/usr/local/bin/orion"
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

#!/usr/bin/env bash
# Update package action with rollback support

update_package() {
    local pkg="$1"
    local bypass="$2"
    local tarball_mode="$3"
    local module_file="$MODULES_DIR/update-$pkg"
    local log_file="$LOG_DIR/update-$pkg-$(date +%Y%m%d-%H%M%S).log"
    
    validate_installation
    init_rollback_system
    
    if ! package_exists "$pkg"; then
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
    
    # Create pre-update rollback point
    log_info "Creating rollback point..."
    local rollback_id=$(create_rollback_point "$pkg" "pre-update")
    
    if [ -z "$rollback_id" ]; then
        log_warning "Failed to create rollback point, continuing anyway..."
    fi
    
    log_info "Updating $pkg..."
    
    # Create log directory if needed
    mkdir -p "$LOG_DIR"
    
    # Execute module with logging and export tarball flag if set
    if [ "$tarball_mode" = "true" ]; then
        export ORION_FORCE_TARBALL="true"
    fi
    
    # Execute update and capture exit code
    local update_success=false
    if bash "$module_file" 2>&1 | tee "$log_file"; then
        update_success=true
    fi
    
    # Check if update was successful
    if $update_success; then
        # Create post-update rollback point
        create_rollback_point "$pkg" "post-update" >/dev/null 2>&1
        
        log_success "$pkg updated successfully"
        log_info "Log saved: $log_file"
        
        # Verify the update worked
        if verify_update "$pkg"; then
            log_success "Update verified successfully"
        else
            log_warning "Update completed but verification failed"
            log_info "You can rollback with: orion rollback $pkg"
        fi
        
        return 0
    else
        log_error "Failed to update $pkg"
        log_info "Check log: $log_file"
        
        # Offer automatic rollback
        if [ -n "$rollback_id" ]; then
            echo
            echo -e "${YELLOW}Update failed! Would you like to rollback? [y/N] ${RESET}"
            read -r rollback_confirm
            if [[ "$rollback_confirm" =~ ^[Yy]$ ]]; then
                execute_rollback "$rollback_id"
            else
                log_info "You can rollback later with: orion rollback $rollback_id"
            fi
        fi
        
        return 1
    fi
}

# Verify that update worked
verify_update() {
    local pkg="$1"
    
    # Simple verification - check if the command still exists
    case $pkg in
        discord)
            # Check if Discord executable exists
            if [ -f "/usr/bin/discord" ] || [ -f "/usr/local/bin/discord" ] || \
               [ -d "/usr/share/discord" ] || [ -d "/opt/discord" ]; then
                return 0
            fi
            ;;
        vscode|code)
            # Check if VSCode executable exists
            if command -v code &>/dev/null; then
                return 0
            fi
            ;;
        *)
            # Generic check - look for the command
            if command -v "$pkg" &>/dev/null; then
                return 0
            fi
            # Check for common binary locations
            if [ -f "/usr/bin/$pkg" ] || [ -f "/usr/local/bin/$pkg" ]; then
                return 0
            fi
            ;;
    esac
    
    return 1
}
