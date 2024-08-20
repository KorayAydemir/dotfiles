# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
DISABLE_UNTRACKED_FILES_DIRTY="true"

WEZTERM="/Applications/WezTerm.app/Contents/MacOS"
export PATH=$PATH:$HOME/go/bin:$HOME/development/flutter/bin:$WEZTERM

alias lg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

function fd () {
    cd "$(find ~/code -mindepth 2 -maxdepth 3 -type d | fzf)";
}
export fd
bindkey -s ^f "fd\n"

alias mcd=~/scripts/mcd.sh

source $ZSH/oh-my-zsh.sh

# For a full list of active aliases, run `alias`.

# bun
#export BUN_INSTALL="$HOME/.bun"
#export PATH="$BUN_INSTALL/bin:$PATH"
