# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# For a full list of active aliases, run `alias`.

ZSH_THEME="robbyrussell"
DISABLE_UNTRACKED_FILES_DIRTY="true"

export JAVA_HOME=$HOME/dev/jdk-21
export PATH=$JAVA_HOME/bin:$PATH

alias ranger="python3 $HOME/dev/ranger/ranger.py"
alias nvim=$HOME/dev/nvim-linux64/bin/nvim
alias i3lock="i3lock -c 000000"
alias csh="~/scripts/cheatsheet.sh"

function fd () {
    cd "$(find ~/code -mindepth 2 -maxdepth 3 -type d | fzf)";
}

export fd

alias mcd=~/scripts/mcd.sh

source $ZSH/oh-my-zsh.sh

# pnpm
alias pn=pnpm

export PNPM_HOME="/Users/kaydemir/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


##### remove terminal padding when certain apps launch #####
#mykitty(){
#kitty @ set-spacing padding=0
#$*
#kitty @ set-spacing padding=default
#}
#alias nvim="mykitty nvim"
#alias cava="mykitty cava"
#alias ranger="mykitty ranger"
######################################
plugins=(git)

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

### nvm ###
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
###########
