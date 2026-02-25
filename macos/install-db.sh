#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-functions.sh"
source_versions

log_info "Starting database tools installation..."

log_info "Installing redis..."
install_brew_package "redis"

log_info "Installing mysql client ${MYSQL_CLIENT_VERSION} for VIM DB connections..."
install_brew_package "mysql-client@${MYSQL_CLIENT_VERSION}"
brew link --overwrite "mysql-client@${MYSQL_CLIENT_VERSION}" --force 2>/dev/null || true

log_success "Database tools installation completed!"

# postgres psql
brew install libpq
echo 'export PATH="/opt/homebrew/opt/libpq/bin:$PATH"' >>~/.zshrc
