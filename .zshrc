# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
DISABLE_UNTRACKED_FILES_DIRTY="true"

function fd () {
    cd "$(find ~/code -mindepth 2 -maxdepth 3 -type d | fzf)";
}

export fd

bindkey -s ^f "fd\n"

alias mcd=~/scripts/mcd.sh
alias pn=pnpm

function tt() {
	current_theme=$(awk '$1=="include" {print $2}' "$HOME/.dotfiles/.config/kitty/kitty.conf")
    echo "$current_theme"
	new_theme="rose-pine.conf"

	if [ "$current_theme" = "rose-pine.conf" ]; then
		new_theme="rose-pine-dawn.conf"
	fi

	# Set theme for active sessions. Requires `allow_remote_control yes`
	kitty @ set-colors --all --configured "~/.config/kitty/$new_theme"

	# Update config for persistence
	sed -i '' -e "s/include.*/include $new_theme/" "$HOME/.dotfiles/.config/kitty/kitty.conf"
}

source $ZSH/oh-my-zsh.sh

# For a full list of active aliases, run `alias`.

# pnpm
export PNPM_HOME="/Users/kaydemir/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
