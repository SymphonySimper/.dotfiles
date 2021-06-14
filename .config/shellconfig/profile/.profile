[[ -f ~/.bashrc ]] && . ~/.bashrc

#Paths
export PATH="$PATH:$HOME/scripts"	#Scripts
export PATH="$PATH:~/flutter/bin" 	#Flutter

#StartX
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
