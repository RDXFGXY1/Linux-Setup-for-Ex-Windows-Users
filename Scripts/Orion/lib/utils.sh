#!/usr/bin/env bash
# Utility functions for Orion

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

# Check if a package exists
package_exists() {
    local pkg="$1"
    local module_file="$MODULES_DIR/update-$pkg"
    
    [ -f "$module_file" ] && return 0 || return 1
}

# Get package version
get_package_version() {
    local pkg="$1"
    local module_file="$MODULES_DIR/update-$pkg"
    
    if [ -f "$module_file" ]; then
        grep -oP '^#\s*Version:\s*\K[\d.]+' "$module_file" 2>/dev/null || echo ""
    fi
}

# Get package description
get_package_description() {
    local pkg="$1"
    local module_file="$MODULES_DIR/update-$pkg"
    
    if [ -f "$module_file" ]; then
        grep -oP '^#\s*Description:\s*\K.*' "$module_file" 2>/dev/null || echo "No description"
    fi
}
