#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-functions.sh"

log_info "Starting UI applications installation..."

install_brew_cask "telegram"

log_info "Installing terminal and development tools..."
install_brew_cask "wezterm"
install_brew_cask "ghostty"

log_info "Installing IDEs"
install_brew_cask "visual-studio-code"

if [ -x "./install-vscode.sh" ]; then
  log_info "Installing VSCode extensions..."
  ./install-vscode.sh
fi

install_brew_cask "rubymine"
install_brew_cask "goland"

log_info "Installing productivity tools..."
install_brew_cask "bitwarden"
install_brew_package "maccy"
install_brew_cask "tailscale"
install_brew_cask "ngrok/ngrok/ngrok"

log_info "Installing utilities..."
install_brew_cask "vlc"
install_brew_cask "grandperspective"

log_info "Installing communication tools..."
install_brew_cask "slack"
install_brew_cask "discord"

log_info "Installing note-taking and documentation..."
install_brew_cask "obsidian"

log_info "Installing media..."
install_brew_cask "obs"
install_brew_cask "spotify"

log_info "Installing window management..."
brew install --cask nikitabobko/tap/aerospace

log_info "Installing extra development tools..."
install_brew_package "bruno"
install_brew_cask "cyberduck"
install_brew_cask "dbeaver-community"

log_info "Installing remote access tools..."
install_brew_cask "vnc-viewer"

log_success "UI applications installation completed!"
