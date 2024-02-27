#!/usr/bin/env bash

# Single user nix install
if [[ ! -d '/nix' ]]; then
	sh <(curl -L https://nixos.org/nix/install) --no-daemon
	mkdir -p "$HOME/.config/nix/" && echo "experimental-features = flakes nix-command" >>"$HOME/.config/nix/nix.conf"
fi
