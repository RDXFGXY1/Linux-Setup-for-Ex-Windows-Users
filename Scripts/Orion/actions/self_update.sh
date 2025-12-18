#!/usr/bin/env bash
# Self update action with rollback support

update_orion_self() {
    # Create backup before updating
    local backup_id=$(backup_orion)
    
    if [ -z "$backup_id" ]; then
        log_warning "Failed to create backup, continuing anyway..."
    else
        log_info "Backup created: $backup_id"
        log_info "You can rollback with: orion rollback $backup_id"
        echo
    fi
    
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
        
        if [ -n "$backup_id" ]; then
            echo
            echo -e "${YELLOW}Update failed! Would you like to rollback? [y/N] ${RESET}"
            read -r rollback_confirm
            if [[ "$rollback_confirm" =~ ^[Yy]$ ]]; then
                restore_orion "$backup_id"
            fi
        fi
        
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
        
        if [ -n "$backup_id" ]; then
            echo
            echo -e "${YELLOW}Update failed! Would you like to rollback? [y/N] ${RESET}"
            read -r rollback_confirm
            if [[ "$rollback_confirm" =~ ^[Yy]$ ]]; then
                restore_orion "$backup_id"
            fi
        fi
        
        return 1
    fi
    
    echo
    log_success "Downloaded $downloaded module(s) from GitHub"
    
    # Update main command
    log_info "Installing main command..."
    if [ -f "$temp_dir/orion.sh" ]; then
        local orion_bin=$(which orion 2>/dev/null || echo "/usr/local/bin/orion")
        sudo cp "$temp_dir/orion.sh" "$orion_bin"
        sudo chmod +x "$orion_bin"
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
    
    # Show rollback info
    if [ -n "$backup_id" ]; then
        echo
        log_info "Previous version backed up as: $backup_id"
        log_info "To rollback: orion rollback $backup_id"
    fi
    
    return 0
}
