#!/usr/bin/env bash
# Version checking functionality

check_for_updates() {
    # Extract current version from this script
    local current_version
    current_version=$(grep -oP '^#\s*Version:\s*\K[\d.]+' "$0" 2>/dev/null) || return 0
    
    # Check if curl is available
    if ! command -v curl >/dev/null 2>&1; then
        return 0
    fi
    
    # Construct GitHub raw content URL
    local github_url="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}/${GITHUB_PATH}/orion.sh"
    
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
