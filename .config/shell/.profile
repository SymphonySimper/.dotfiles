# Helper functions
is_present_prog(){
	if which $1 | grep -q 'not found'; then
		return 1
	else
		return 0
	fi
}
select_default_prog(){
	if is_present_prog "$2"; then
		export "$1"="$2"
	elif is_present_prog "$3"; then
		export "$1"="$3"
	elif [ -n "$4" ]; then
		is_present_prog "$4" \
			&& export "$1"="$4"
	fi
}

## Default Programs
export READER="zathura"
export IMAGE_VIEWER="sxiv"
export VIDEO_PLAYER="mpv"
export RSS_READER="newsboat"

select_default_prog 'BROWSER' 'librewolf' 'firefox' 'chromium'
select_default_prog 'PERM' 'doas' 'sudo'
select_default_prog 'EDITOR' 'nvim' 'vim' 'nano'
export VISUAL="$EDITOR"
select_default_prog 'TERMINAL' 'urxvtc' 'alacritty' 'kitty'
select_default_prog 'SECOND_TERMINAL' 'urxvt' 'alacritty' 'kitty'
select_default_prog 'SWALLOW' 'devour' ''
select_default_prog 'USE_GPU' 'prime-run' ''

# Paths
export PATH="$PATH:$HOME/.local/bin"					# Scripts
export PATH="$PATH:$HOME/.local/bin/aliases"			# Alias scripts
export PATH="$PATH:$HOME/.local/bin/gen"				# Gen scripts
export PATH="$PATH:$HOME/lifeisfun/lang/flutter/bin" 	# Flutter

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
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export ANDROID_SDK_ROOT="$XDG_DATA_HOME"/android
export CHROME_EXECUTABLE="chromium"
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode
export ATOM_HOME="$XDG_DATA_HOME"/atom

# My loc exports
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
# export STARSHIP_CONFIG="$HOME"/.config/starship/config.toml
export VIMWIKI="$XDG_DATA_HOME"/vimwiki


[ -f "$XDG_DATA_HOME"/cargo/env ] && . "$XDG_DATA_HOME"/cargo/env

# Other settinfs
export _JAVA_AWT_WM_NONREPARENTING=1
export MANPAGER='less -Q'
# export __NV_PRIME_RENDER_OFFLOAD=1
# export __GLX_VENDOR_LIBRARY_NAME="nvidia"
# export __VK_LAYER_NV_optimus="NVIDIA_only"

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

	export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
	--no-mouse --reverse --preview-window=border-none \
	--color=bg+:$color00,spinner:$color0C,hl:$color0D \
	--color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C \
	--color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

	}

_gen_fzf_default_opts

# window manager name
[ -f "$XINITRC" ] && export WM="$(tail -n 1 "$XINITRC" | cut -d ' ' -f 4)"

# StartX
[ "$(tty)" = "/dev/tty1" ] && exec startx "$XINITRC" > /dev/null 2>&1
