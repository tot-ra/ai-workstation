#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-functions.sh"

log_info "Starting AI tools installation..."

install_brew_cask "codex-app"

install_brew_cask "superwhisper"

log_info "Installing OpenCode CLI..."
install_brew_package "anomalyco/tap/opencode"

log_info "Installing sag (ElevenLabs TTS)..."
install_brew_package "steipete/tap/sag"

log_info "Installing LM Studio..."
install_brew_cask "lm-studio"

if [ -f "$HOME/.cache/lm-studio/bin/lms" ]; then
  log_skip "LM Studio CLI already bootstrapped"
else
  if [ -d "$HOME/.cache/lm-studio/bin" ]; then
    log_info "Bootstrapping LM Studio CLI..."
    ~/.cache/lm-studio/bin/lms bootstrap
    log_success "LM Studio CLI bootstrapped"
  else
    log_info "LM Studio needs to be opened first to bootstrap CLI"
  fi
fi

log_success "AI tools installation completed!"
