#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common-functions.sh"
source_versions

log_info "Starting CLI tools installation..."

log_info "Updating brew..."
brew update
brew upgrade

if ! command_exists zsh; then
  log_info "Installing zsh and oh-my-zsh..."
  sudo sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  compaudit | xargs chmod g-w,o-w
  log_success "zsh installed"
else
  log_skip "zsh already installed"
fi

log_info "Installing fonts..."
brew tap homebrew/cask-fonts 2>/dev/null || true
install_brew_package "font-hack-nerd-font"
install_brew_package "font-jetbrains-mono-nerd-font"

log_info "Installing powerlevel10k..."
install_brew_package "powerlevel10k"
if ! grep -q "powerlevel10k.zsh-theme" ~/.zshrc 2>/dev/null; then
  echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
  log_info "Added powerlevel10k to .zshrc"
fi

log_info "Installing zsh plugins..."
install_brew_package "zsh-autosuggestions"
if ! grep -q "zsh-autosuggestions.zsh" ~/.zshrc 2>/dev/null; then
  echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
fi

install_brew_package "zsh-syntax-highlighting"
if ! grep -q "zsh-syntax-highlighting.zsh" ~/.zshrc 2>/dev/null; then
  echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc
fi

log_info "Installing file managers..."
install_brew_package "mc"
install_brew_package "yazi"
install_brew_package "ffmpegthumbnailer"
install_brew_package "sevenzip"
install_brew_package "jq"
install_brew_package "poppler"
install_brew_package "fd"
install_brew_package "ripgrep"
install_brew_package "imagemagick"
install_brew_package "font-symbols-only-nerd-font"

log_info "Installing search and navigation tools..."
install_brew_package "fzf"
install_brew_package "eza"
install_brew_package "zoxide"
install_brew_package "bat"

log_info "Installing utilities..."
install_brew_package "parallel"
install_brew_package "gnu-sed"

log_info "Installing monitoring tools..."
install_brew_package "btop"
install_brew_package "htop"
install_brew_package "procs"

if ! sudo grep -q "NOPASSWD.*procs" /etc/sudoers 2>/dev/null; then
  sudo tee -a /etc/sudoers <<<"$USER ALL= NOPASSWD: /usr/local/bin/procs" >/dev/null
  log_info "Added procs to sudoers"
fi

log_info "Installing text processing tools..."
install_brew_package "jless"
install_brew_package "hexyl"
install_brew_package "yq"
install_brew_package "noahgorstein/tap/jqp"

log_info "Installing networking tools..."
install_brew_package "wget"
install_brew_package "curl"
install_brew_package "telnet"
install_brew_package "ncdu"
install_brew_package "tldr"

## make sure to use latest curl
echo 'export PATH="/opt/homebrew/opt/curl/bin:$PATH"' >>~/.zshrc

log_success "CLI tools installation completed!"
