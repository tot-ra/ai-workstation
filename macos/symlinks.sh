#!/bin/bash
set -e

echo "Creating symlinks for configuration files"

# Helper function to create symlink
link_config() {
    local src="$1"
    local dest="$2"
    
    # Remove existing file/symlink if it exists
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        rm -rf "$dest"
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"
    
    # Create symlink
    ln -s "$src" "$dest"
    echo "Linked: $dest -> $src"
}

# Tmux config
link_config "$HOME/git/ai-workstation/.tmux.conf" "$HOME/.tmux.conf"

# Nvim config
link_config "$HOME/git/ai-workstation/.config/nvim" "$HOME/.config/nvim"

# Wezterm config
link_config "$HOME/git/ai-workstation/.config/wezterm" "$HOME/.config/wezterm"

# Opencode config directory
link_config "$HOME/git/ai-workstation/.config/opencode" "$HOME/.config/opencode"

# Opencode rules and skills directory (referenced by opencode.jsonc)
link_config "$HOME/git/ai-workstation/.opencode" "$HOME/.opencode"

# AeroSpace window manager config
link_config "$HOME/git/ai-workstation/.config/aerospace.toml" "$HOME/.aerospace.toml"

echo "Symlinks created successfully"
echo ""
echo "Note: Make sure to run this script on each machine where you want to use these configs."
echo "The workstation repo should contain actual files, not symlinks."
