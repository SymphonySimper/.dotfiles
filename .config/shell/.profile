#Default Programs
export EDITOR="nvim"

#Paths
export PATH="$PATH:$HOME/.local/bin"		#Scripts
export PATH="$PATH:$HOME/.local/bin/aliases"	#Alias scripts
export PATH="$PATH:~/flutter/bin" 		#Flutter

export ZDOTDIR="$HOME/.config/shell/zsh"
export STARSHIP_CONFIG="$HOME/.config/starship/config.toml"

export _JAVA_AWT_WM_NONREPARENTING=1

#StartX
#[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
[ "$(tty)" = "/dev/tty1" ] && exec startx
