#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
(cat ~/.cache/wal/sequences &)

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

# PS1='[\u@\h \W]\$ '
PS1="\W > "

#shopt -s autocd

#Alias and Functions
alias config='/usr/bin/git --git-dir=/home/s2b/.cfg/ --work-tree=/home/s2b'

########
#Source#
########

sloc="$HOME/.config/shell"
for f in $sloc/*; do source "$f"; done

#Starship
eval "$(starship init bash)"
