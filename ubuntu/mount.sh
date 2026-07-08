alias n="nvim"
alias o="opencode"
alias cc="claude --allow-dangerously-skip-permissions"
alias ls="eza --long --header --icons --octal-permissions --no-user --no-permissions"

# better cd
if [ -n "$ZSH_VERSION" ]; then
    eval "$(zoxide init zsh)"
elif [ -n "$BASH_VERSION" ]; then
    eval "$(zoxide init bash)"
fi

# name tmux sessions after the current directory
alias tm='tmux new -s `basename $PWD`'

alias cat="bat"

# init pyenv (already initialized in .zshrc)
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - bash)"
