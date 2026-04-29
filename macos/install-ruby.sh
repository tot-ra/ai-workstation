#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-functions.sh"
source_versions

RUBY_VERSION="${RUBY_VERSION:-3.2.3}"
ASDF_SHIMS_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
ASDF_PREFIX="$(brew --prefix asdf)"
ASDF_SCRIPT="$ASDF_PREFIX/libexec/asdf.sh"

log_info "Starting Ruby installation..."

install_brew_package "asdf"
install_brew_package "openssl@3"
install_brew_package "readline"
install_brew_package "libyaml"
install_brew_package "gmp"
install_brew_package "rust"
install_brew_package "autoconf"
install_brew_package "automake"
install_brew_package "libtool"

if ! grep -Fq "$ASDF_SHIMS_DIR" ~/.zshrc 2>/dev/null; then
  echo "export PATH=\"$ASDF_SHIMS_DIR:\$PATH\"" >>~/.zshrc
  log_info "Added asdf shims to .zshrc"
fi

if [ -f "$ASDF_SCRIPT" ]; then
  if ! grep -Fq "$ASDF_SCRIPT" ~/.zshrc 2>/dev/null; then
    echo ". \"$ASDF_SCRIPT\"" >>~/.zshrc
    log_info "Added asdf init to .zshrc"
  fi
else
  log_skip "asdf shell init script not found; using asdf executable"
fi

if ! command_exists asdf; then
  export PATH="$ASDF_PREFIX/bin:$PATH"
fi
export PATH="$ASDF_SHIMS_DIR:$PATH"
if [ -f "$ASDF_SCRIPT" ]; then
  # shellcheck disable=SC1090
  . "$ASDF_SCRIPT"
fi

if ! command_exists asdf; then
  log_error "asdf command not found after installation"
  exit 1
fi

if ! asdf plugin list | grep -qx 'ruby'; then
  log_info "Adding asdf ruby plugin..."
  asdf plugin add ruby
else
  log_skip "asdf ruby plugin already installed"
fi

if ! asdf list ruby 2>/dev/null | tr -d ' *' | grep -qx "$RUBY_VERSION"; then
  log_info "Installing Ruby $RUBY_VERSION..."
  RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)" asdf install ruby "$RUBY_VERSION"
else
  log_skip "Ruby $RUBY_VERSION already installed"
fi

log_info "Setting Ruby $RUBY_VERSION as global default..."
asdf set -u ruby "$RUBY_VERSION"
asdf reshim ruby "$RUBY_VERSION"
hash -r

log_info "Installing Bundler for Ruby $RUBY_VERSION..."
gem install bundler

log_success "Ruby installation completed"
log_info "ruby: $(command -v ruby)"
log_info "ruby version: $(ruby -v)"
log_info "bundler version: $(bundle -v)"
log_info "Open a new shell or run: exec zsh"
