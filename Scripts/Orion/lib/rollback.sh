#!/usr/bin/env bash
# Rollback functionality for Orion itself

ROLLBACK_DIR="$INSTALL_DIR/rollbacks"
BACKUP_DIR="$INSTALL_DIR/backups"
MAX_BACKUPS=3

# Initialize rollback system
init_rollback_system() {
    mkdir -p "$ROLLBACK_DIR"
    mkdir -p "$BACKUP_DIR"
}

# Create backup of current Orion installation
backup_orion() {
    local backup_id="orion_$(date +%Y%m%d-%H%M%S)"
    local backup_path="$BACKUP_DIR/$backup_id"
    
    log_info "Creating Orion backup: $backup_id"
    
    mkdir -p "$backup_path"
    
    # Backup main executable
    local orion_bin=$(which orion 2>/dev/null || echo "/usr/local/bin/orion")
    if [ -f "$orion_bin" ]; then
        cp "$orion_bin" "$backup_path/orion.sh"
        log_success "Backed up main executable"
    fi
    
    # Backup lib directory
    if [ -d "$INSTALL_DIR/lib" ]; then
        cp -r "$INSTALL_DIR/lib" "$backup_path/"
        log_success "Backed up lib directory"
    fi
    
    # Backup actions directory
    if [ -d "$INSTALL_DIR/actions" ]; then
        cp -r "$INSTALL_DIR/actions" "$backup_path/"
        log_success "Backed up actions directory"
    fi
    
    # Backup modules directory
    if [ -d "$INSTALL_DIR/modules" ]; then
        cp -r "$INSTALL_DIR/modules" "$backup_path/"
        log_success "Backed up modules directory"
    fi
    
    # Create backup info file
    local current_version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$orion_bin" 2>/dev/null || echo "unknown")
    cat > "$backup_path/backup.info" << EOF
Backup ID: $backup_id
Timestamp: $(date)
Orion Version: $current_version
Backup Path: $backup_path
EOF
    
    log_success "Orion backup created: $backup_id"
    echo "$backup_id"
    
    # Clean up old backups
    cleanup_old_backups
}

# Restore Orion from backup
restore_orion() {
    local backup_id="$1"
    local backup_path="$BACKUP_DIR/$backup_id"
    
    if [ ! -d "$backup_path" ]; then
        log_error "Backup not found: $backup_id"
        return 1
    fi
    
    log_info "Restoring Orion from backup: $backup_id"
    
    # Restore main executable
    if [ -f "$backup_path/orion.sh" ]; then
        local orion_bin=$(which orion 2>/dev/null || echo "/usr/local/bin/orion")
        sudo cp "$backup_path/orion.sh" "$orion_bin"
        sudo chmod +x "$orion_bin"
        log_success "Restored main executable"
    fi
    
    # Restore lib directory
    if [ -d "$backup_path/lib" ]; then
        sudo rm -rf "$INSTALL_DIR/lib" 2>/dev/null || true
        sudo cp -r "$backup_path/lib" "$INSTALL_DIR/"
        log_success "Restored lib directory"
    fi
    
    # Restore actions directory
    if [ -d "$backup_path/actions" ]; then
        sudo rm -rf "$INSTALL_DIR/actions" 2>/dev/null || true
        sudo cp -r "$backup_path/actions" "$INSTALL_DIR/"
        log_success "Restored actions directory"
    fi
    
    # Restore modules directory
    if [ -d "$backup_path/modules" ]; then
        sudo rm -rf "$INSTALL_DIR/modules" 2>/dev/null || true
        sudo cp -r "$backup_path/modules" "$INSTALL_DIR/"
        log_success "Restored modules directory"
    fi
    
    log_success "Orion restored successfully from backup: $backup_id"
    
    # Log the rollback
    local rollback_file="$ROLLBACK_DIR/${backup_id}_restored.log"
    cat > "$rollback_file" << EOF
Rollback executed: $(date)
From backup: $backup_id
Restored to: $INSTALL_DIR
EOF
    
    return 0
}

# List available backups
list_backups() {
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        log_info "No backups available"
        return 0
    fi
    
    echo -e "${CYAN}${BOLD}Available Orion Backups:${RESET}"
    echo
    
    for backup in "$BACKUP_DIR"/*; do
        if [ -d "$backup" ]; then
            local backup_id=$(basename "$backup")
            local info_file="$backup/backup.info"
            
            echo -e "  ${GREEN}${backup_id}${RESET}"
            
            if [ -f "$info_file" ]; then
                local version=$(grep "Orion Version:" "$info_file" | cut -d: -f2 | xargs)
                local timestamp=$(grep "Timestamp:" "$info_file" | cut -d: -f2- | xargs)
                echo -e "    ${CYAN}Version:${RESET} $version"
                echo -e "    ${CYAN}Time:${RESET} $timestamp"
            fi
            
            # Show backup size
            local size=$(du -sh "$backup" 2>/dev/null | cut -f1)
            echo -e "    ${CYAN}Size:${RESET} $size"
            echo
        fi
    done
}

# Clean up old backups
cleanup_old_backups() {
    if [ ! -d "$BACKUP_DIR" ]; then
        return 0
    fi
    
    # Get backups sorted by date (oldest first)
    local backups=($(ls -1t "$BACKUP_DIR" 2>/dev/null | tail -n +$((MAX_BACKUPS + 1))))
    
    for backup_id in "${backups[@]}"; do
        if [ -n "$backup_id" ] && [ -d "$BACKUP_DIR/$backup_id" ]; then
            rm -rf "$BACKUP_DIR/$backup_id"
            log_info "Removed old backup: $backup_id"
        fi
    done
}

# Get latest backup
get_latest_backup() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo ""
        return 1
    fi
    
    local latest=$(ls -1t "$BACKUP_DIR" 2>/dev/null | head -1)
    
    if [ -n "$latest" ] && [ -d "$BACKUP_DIR/$latest" ]; then
        echo "$latest"
    else
        echo ""
    fi
}

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
