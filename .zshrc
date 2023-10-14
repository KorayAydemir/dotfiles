# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
DISABLE_UNTRACKED_FILES_DIRTY="true"

mykitty(){
kitty @ set-spacing padding=0
$*
kitty @ set-spacing padding=default
}
alias nvim="mykitty nvim"
alias cava="mykitty cava"
alias ranger="mykitty ranger"
alias tm="tmux"
alias i3lock="i3lock -c 000000"
alias csh="~/scripts/cheatsheet.sh"

function fd () {
    cd "$(find ~/code -mindepth 2 -maxdepth 3 -type d | fzf)";
}

export fd

bindkey -s ^f "fd\n"

alias mcd=~/scripts/mcd.sh
alias pn=pnpm

source $ZSH/oh-my-zsh.sh

# For a full list of active aliases, run `alias`.

# pnpm
export PNPM_HOME="/Users/kaydemir/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
