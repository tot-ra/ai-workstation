#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-functions.sh"
source_versions

log_info "Installing mise and fnox..."

install_brew_package "mise"

MISE_BIN="$(brew --prefix)/bin/mise"
if [ ! -x "$MISE_BIN" ]; then
  MISE_BIN="$(command -v mise)"
fi

ZSHRC="$HOME/.zshrc"
MISE_ACTIVATE_LINE="eval \"\$($MISE_BIN activate zsh)\""

touch "$ZSHRC"

if ! grep -q "mise activate zsh" "$ZSHRC" 2>/dev/null; then
  {
    echo ""
    echo "# Activate mise for tool versions and global tools like fnox"
    echo "$MISE_ACTIVATE_LINE"
  } >>"$ZSHRC"
  log_info "Added mise activation to .zshrc"
else
  log_skip "mise activation already configured in .zshrc"
fi

"$MISE_BIN" use -g -y "fnox@${FNOX_VERSION:-latest}"
"$MISE_BIN" exec fnox -- fnox --version | tee -a "$LOG_FILE"

log_success "mise and fnox installation completed!"
