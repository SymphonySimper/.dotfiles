# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable colors and change prompt:
autoload -U colors && colors

# Prompt
precmd(){ precmd(){ echo ; }; }

# if [ -n "$SSH_CONNECTION" ]; then
# 	cs="(ssh) "
# fi
#
# # function to get current git branch
# get_git_branch(){
# 	ref=$(git symbolic-ref --short HEAD 2> /dev/null)
# 	[ $(echo $ref |wc -w) -eq 1 ] && branch="%f%b ($ref)" || branch=""
# 	echo $branch
# }
#
# # Should be in single quotes to make re run on directory changes
# # setopt PROMPT_SUBST enable to run commands in PROMPT when enclosed with single quotes
# setopt PROMPT_SUBST
# # PROMPT='%B%F{240}%~$(get_git_branch)%f%B
# # ${cs}>%b '
#
# PROMPT='%B%~$(get_git_branch)%B
# ${cs}>%b '

# Turn off beep
unsetopt BEEP

# Automatically cd into typed directory.
setopt autocd
setopt auto_pushd

# Disable ctrl-s to freeze terminal.
stty stop undef
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME"/.cache/zsh-history

autoload -U compinit && compinit -u
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Keybinds
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# My Binds

key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

bindkey \^u backward-kill-line
bindkey \^k kill-line
bindkey \^y yank

bindkey -s '^f' 'j\n'
bindkey -s '^p' 'jj\n'
bindkey -s '^b' 'huh\n'
bindkey -s '^s' 'fes\n'
bindkey -s '^g' 'fec\n'
bindkey -s '^h' 'fesh\n'
bindkey -s '^v' 'fv\n'
bindkey -s '^a' 'fa\n'

# vi mode
bindkey -v
export KEYTIMEOUT=1

cursorBeam='\e[6 q'
cursorBlock='\e[2 q'

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne "$cursorBlock";;      # block
        viins|main) echo -ne "$cursorBeam";; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "$cursorBeam"
}
zle -N zle-line-init
echo -ne "$cursorBeam" # Use beam shape cursor on startup.
preexec() { echo -ne "$cursorBeam" ;} # Use beam shape cursor for each new prompt.

# this is to yank to system/primary clipboard in vi mode
vi-yank-xclip() { zle vi-yank; echo "$CUTBUFFER" | yoink; }
zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lfp -last-dir-path="$tmp"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'
bindkey -s '^q' 'bc -lq\n'
bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Alias and Functions
alias config='/usr/bin/git --git-dir="$HOME"/.cfg/ --work-tree="$HOME"'
# Source
sloc="$HOME/.config/shell/"
for f in $sloc*; do source "$f"; done

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/symph/.local/share/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/symph/.local/share/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/symph/.local/share/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/symph/.local/share/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(starship init zsh)"
