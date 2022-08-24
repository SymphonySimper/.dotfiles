# Helper functions
is_present_prog(){ command -v "$1" > /dev/null 2>&1 && return 0 || return 1; }
select_default_prog(){
	key="$1"
	shift
	for p in "$@"; do
		is_present_prog "$p" && { export "$key"="$p"; break; }
	done
}

# WSL
if  echo $(uname -r) | grep -wqi 'microsoft'; then
	wsl=true
else
	wsl=false
fi
export WSL=$wsl


# Paths
add_path(){ [ -d "$1" ] && export PATH="$PATH:$1"; }
add_path "$HOME/.local/bin"						# Scripts
add_path "$HOME/.local/bin/aliases"				# Alias scripts
add_path "$HOME/.local/bin/gen"					# Gen scripts
add_path "$HOME/.local/bin/helper"				# Helper scripts
add_path "$HOME/.local/appimage"				# Appimages
is_present_prog ruby && export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
add_path "$HOME/lifeisfun/lang/flutter/bin" 	# Flutter
add_path "$GEM_HOME/bin"						# Ruby
add_path "$HOME/Android/Sdk/emulator"			# Android Emulator

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_STATE_HOME="$HOME"/.local/state

export XINITRC="$XDG_CONFIG_HOME"/x11/xinitrc
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
# export HISTFILE="$XDG_DATA_HOME"/bash/history
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export WGETRC="$XDG_CONFIG_HOME"/wgetrc
export SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
# export RUST_BACKTRACE='1'
export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd
export GOPATH="$XDG_DATA_HOME"/go
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME"/android
export ANDROID_HOME="$XDG_DATA_HOME"/android
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export ANDROID_SDK_ROOT="$XDG_DATA_HOME"/android
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode
export ATOM_HOME="$XDG_DATA_HOME"/atom
# pyenv
export PYENV_ROOT="$XDG_CONFIG_HOME"/.pyenv
add_path "$PYENV_ROOT/bin"

# My loc exports
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
# export STARSHIP_CONFIG="$HOME"/.config/starship/config.toml
export VIMWIKI="$XDG_DATA_HOME"/mywiki

if $WSL; then
	while read -r folder; do
		add_path $folder
	done <<- EOF
		$(find /mnt/c/Program\ Files/ -maxdepth 1 -type d)
		EOF
fi

[ -f "$XDG_DATA_HOME"/cargo/env ] && . "$XDG_DATA_HOME"/cargo/env

## Default Programs
if $WSL; then
	# export READER=''
	# export IMAGE_VIEWER='cmd.exe /c start ms-photos:'
	export VIDEO_PLAYER='mpv.exe'
	select_default_prog 'BROWSER' 'firefox.exe' 'chromium.exe' 'brave.exe' 'chrome.exe'
	select_default_prog 'TERMINAL' 'kitty.exe' 'alacritty.exe'
	select_default_prog 'SECOND_TERMINAL' 'wt.exe'
	select_default_prog 'CHROME_EXECUTABLE' 'chromium.exe' 'brave.exe' 'MicrosoftEdge.exe'
	select_default_prog 'TORRENT' 'qbittorrent.exe'
else
	export READER="zathura"
	export IMAGE_VIEWER="sxiv"
	export VIDEO_PLAYER="mpv"
	select_default_prog 'BROWSER' 'librewolf' 'firefox' 'chromium' 'brave' 'io.gitlab.librewolf-community' 'com.github.Eloston.UngoogledChromium'
	select_default_prog 'TERMINAL' 'urxvtc' 'alacritty' 'kitty'
	select_default_prog 'SECOND_TERMINAL' 'urxvt' 'alacritty' 'kitty'
	select_default_prog 'CHROME_EXECUTABLE' 'chromium' 'brave' 'com.brave.Browser' 'com.github.Eloston.UngoogledChromium'
	select_default_prog 'TORRENT' 'qbittorrent'
fi

export RSS_READER="newsboat"
select_default_prog 'PERM' 'doas' 'sudo'
select_default_prog 'EDITOR' 'nvim' 'vim' 'nano'
export VISUAL="$EDITOR"
select_default_prog 'SWALLOW' 'devour'
select_default_prog 'USE_GPU' 'prime-run'

export LESS='-NQ --use-color --color=N238'
export GAMEMODERUNEXEC="prime-run"

# Other settings
export _JAVA_AWT_WM_NONREPARENTING=1

# fzf
# https://github.com/fnune/base16-fzf/blob/master/bash/base16-grayscale-dark.config
_gen_fzf_default_opts() {
	local color00='#000000'
	local color01='#252525'
	local color02='#464646'
	local color03='#525252'
	local color04='#ababab'
	local color05='#b9b9b9'
	local color06='#e3e3e3'
	local color07='#f7f7f7'
	local color08='#7c7c7c'
	local color09='#999999'
	local color0A='#a0a0a0'
	local color0B='#8e8e8e'
	local color0C='#868686'
	local color0D='#686868'
	local color0E='#747474'
	local color0F='#5e5e5e'

	# --preview='"$HOME"/.local/bin/helper/fzf-preview {}' \
	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
		--no-mouse --reverse --preview-window=border-none \
		--color=bg+:$color00,spinner:$color0C,hl:$color0D \
		--color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C \
		--color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
}

_gen_fzf_default_opts

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=30;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.cfg=00;32:*.conf=00;32:*.diff=00;32:*.doc=00;32:*.ini=00;32:*.log=00;32:*.patch=00;32:*.pdf=00;32:*.ps=00;32:*.tex=00;32:*.txt=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';

# Timezone
export TZ='Asia/Kolkata'

# Wallpaper
export WALLPAPER="$XDG_DATA_HOME"/mypics/bg.png

# Home Brew
[ -d '/home/linuxbrew/.linuxbrew' ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Distro
exp_distro(){ export DISTRO="$(grep -w $1 /etc/os-release | cut -d '=' -f 2)"; }
if grep -wq 'ID_LIKE' /etc/os-release; then
	exp_distro 'ID_LIKE'
else
	exp_distro 'ID'
fi

# Window manager name
[ -f "$XINITRC" ] && export WM="$(grep -v '^#' "$XINITRC" | tail -n 1 | cut -d ' ' -f 4)"

# StartX
[ "$(tty)" = "/dev/tty1" ] && exec startx "$XINITRC" > /dev/null 2>&1
