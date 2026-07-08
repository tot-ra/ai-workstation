# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# dont warn about echoing on new terminal
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# alias code='open -a "Visual Studio Code" .'

# better cd
eval "$(zoxide init zsh)"
#alias cd="z"

alias o="opencode"
alias n="nvim"
alias k="kubectl"
alias cc="claude --allow-dangerously-skip-permissions"

# name tmux sessions after the current directory
alias tm='tmux new -s `basename $PWD`'

alias ls="eza --long --header --icons --git --octal-permissions --no-user --no-permissions"

alias sl="screen -ls"

alias cat="bat"
alias encode_video="ffmpeg -i input.mov -c:v libx265 -crf 32 -preset slow -c:a aac -b:a 96k -movflags +faststart output.mp4"

#alias python="$(brew --prefix python@3.11)/libexec/bin/python"

