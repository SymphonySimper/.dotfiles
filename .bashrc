#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# PS1='[\u@\h \W]\$ '
PS1="\W > "

#shopt -s autocd

#Alias and Functions
alias config='/usr/bin/git --git-dir=/home/s2b/.cfg/ --work-tree=/home/s2b'
alias ls='ls --color=auto'
alias cd='cd && ls'
alias vi='nvim'
alias svi='sudo vim'

#Alias for dot files
alias cgs='config status'
cgm(){ config commit -m "$1"; }
cgamp(){ config add -u && config commit -m "$1" && config push; }
alias cgp='config push'
alias cga='config add'
alias cgau='config add -u'

#Git alias
alias g='git'
alias gs='git status'
gm(){ git commit -m "$1"; }
gamp(){ git add -u && git commit -m "$1" && git push; }
alias gp='git push'
alias ga='git add'
alias gau='git add -u'
alias gnotrack='git config --local status.showUntrackedFiles no'

#Folders
alias ..='cd ..'
alias cdreact='cd ~/lifeisfun/react'

#Scrcpy and wireless adb
alias myscrcpy='scrcpy -f -n -m 1920'
adbcnt(){ adb connect $1; }

#Maintenance
alias rmcache='rm -rf ~/.cache/*'
alias rmme='rm -rf ~/.local/share/Trash/*'
alias rmlinks='find . -xtype l -exec rm {} \;'

#Pacman/Packages/Yay
alias sp='sudo pacman'
alias prm='sp -Rcns'
alias amifat='pacman -Q | wc -l'
alias rmzombies='sp -Rns $(pacman -Qdtq)'
alias y='yay'
alias yrm='y -Rcns'

#Tasks
alias bye='poweroff'
alias q='exit'
fnd(){ find ~ -name "$1"; }
alias imlight='ps_mem -p $(pgrep -d, -u $USER)'

#Mount
alias mountnobita='sudo ntfs-3g /dev/sdb1 ~/nobita/'
alias umountnobita='sudo umount /dev/sdb1'
alias mountusb='sudo mount -o umask=0,uid=nobody,gid=nobody'

#Audio
alias audio='pulsemixer --color 0'

#Video
alias myface='ffplay /dev/video0 -loglevel quiet &disown'
#p(){ ffplay "$1" -loglevel quiet -autoexit; }
#pws(){ ffplay -vf "subtitles=$1:force_style='FontName=Poppins,Fontsize=24'" "$2" -loglevel quiet -autoexit; }
p(){ mpv "$1"; }

#PDF
pdf(){ zathura "$1" &disown; }

#Flutter
export PATH="$PATH:~/flutter/bin"

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
