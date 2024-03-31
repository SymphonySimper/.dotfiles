#!/usr/bin/env bash

dir="$HOME/.local/share/my/pics/wallpapers/"

function create_config() {
	printf 'ipc = off\npreload = %s\nwallpaper = ,%s\n' "$1" "$1" >"$HOME/.config/hypr/hyprpaper.conf"
}

if [[ -d $dir ]]; then
	wallpaper="$(find "$dir" -not -path '*.git/*' -not -name "*.py" -type f | sort -R | head -n1)"
	create_config "$wallpaper"
else
	create_config "$HOME/.local/share/my/pics/bg.png"
fi
hyprpaper
