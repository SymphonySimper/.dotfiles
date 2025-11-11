#!/usr/bin/env bash

flakes=("nix-community/disko" "nix-community/home-manager" "nix-community/NixOS-WSL" "catppuccin/nix" "helix-editor/helix")

last_saturday="$(date -d 'last saturday' +%Y-%m-%d)"
saturday="$(date -d 'saturday' +%Y-%m-%d)"

for flake in "${flakes[@]}"; do
  xdg-open "https://github.com/${flake}/commits?since=${last_saturday}&until=${saturday}" >/dev/null 2>&1
done
