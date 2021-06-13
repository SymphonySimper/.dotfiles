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
alias vi='nvim'
alias svi='sudo nvim'

#Alias for dot files
alias cgs='config status'
cgm(){ config commit -m "$1"; }
cgamp(){ config add -u && config commit -m "$1" && config push; }
alias cgp='config push'
alias cga='config add'
alias cgau='config add -u'

#Git alias
alias g='git'
alias gc='git clone'
alias gs='git status'
gm(){ git commit -m "$1"; }
gamp(){ git add -u && git commit -m "$1" && git push; }
alias gp='git pull'
alias ga='git add'
alias gau='git add -u'
alias gnotrack='git config --local status.showUntrackedFiles no'

#Folders
alias ..='cd ..'
alias cdreact='cd ~/lifeisfun/react/'
alias cdflutter='cd ~/lifeisfun/flutter/'

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
yoink(){ xclip -sel c < "$1"; }

#Mount
alias mountnobita='sudo ntfs-3g /dev/sdb1 ~/nobita/'
alias umountnobita='sudo umount /dev/sdb1'
alias mountusb='sudo mount -o umask=0,uid=nobody,gid=nobody'

#Audio
alias audio='pulsemixer --color 0'

#Video
alias p='bash ~/scripts/video'

#PDF
pdf(){ zathura "$1" &disown; }


#File/Dir permission
alias letmein='sudo chmod 777' 
letItGo(){ chmod +x "$1"; }

#Scripts
alias song='bash ~/scripts/spotifydrun'
anime(){ bash ~/ani-cli/ani-cli "$1"; }

#Lazy Functions

#ToDo
todo(){
	loc=~/todo
	case $1 in
		-s) cat $loc ;;
		*) nvim $loc ;;
	esac;
}

#Dwm
newDwm(){ cp config.def.h config.h && sudo make clean install; }



#############
#Don't touch#
#############

#Flutter
export PATH="$PATH:~/flutter/bin"

#Rank Arch Servers
alias lennaDropCaches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
alias lennaUpdateAll='export TMPFILE="$(mktemp)"; \
	sudo true; \
	rate-arch-mirrors --max-delay=21600 --save=$TMPFILE \
	  && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
	  && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
	  && lennaDropCaches \
	  && yay -Syyu --noconfirm'
#Startx
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
