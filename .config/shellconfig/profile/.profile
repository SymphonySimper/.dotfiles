[[ -f ~/.bashrc ]] && . ~/.bashrc

#Default Programs
export EDITOR="nvim"

#Paths
export PATH="$PATH:$HOME/scripts"	#Scripts
export PATH="$PATH:~/flutter/bin" 	#Flutter

export _JAVA_AWT_WM_NONREPARENTING=1

#StartX
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
