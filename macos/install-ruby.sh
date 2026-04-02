#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-functions.sh"
source_versions

RUBY_VERSION="${RUBY_VERSION:-3.2.3}"
ASDF_SHIMS_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
ASDF_SCRIPT="$(brew --prefix asdf)/libexec/asdf.sh"

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
    echo "export PATH=\"$ASDF_SHIMS_DIR:\$PATH\"" >> ~/.zshrc
    log_info "Added asdf shims to .zshrc"
fi

if ! grep -Fq "$ASDF_SCRIPT" ~/.zshrc 2>/dev/null; then
    echo ". \"$ASDF_SCRIPT\"" >> ~/.zshrc
    log_info "Added asdf init to .zshrc"
fi

export PATH="$ASDF_SHIMS_DIR:$PATH"
# shellcheck disable=SC1090
. "$ASDF_SCRIPT"

if ! asdf plugin list | grep -qx 'ruby'; then
    log_info "Adding asdf ruby plugin..."
    asdf plugin add ruby
else
    log_skip "asdf ruby plugin already installed"
fi

if ! asdf list ruby 2>/dev/null | tr -d ' ' | grep -qx "$RUBY_VERSION"; then
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
