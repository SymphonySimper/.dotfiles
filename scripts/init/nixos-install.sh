#!/usr/bin/env bash

profile="$1"
if [ -z "$profile" ]; then
  echo "No profile passed (ex: gui)."
  exit 1
fi

echo "Set SSH password"
passwd

ip_addr="$(ip -brief -4 addr | tail -n1 | awk '{print $3}' | tr -d ' ' | cut -d '/' -f1)"
echo "IP address: ${ip_addr}"

nix --extra-experimental-features 'nix-command flakes' run 'github:nix-community/nixos-anywhere' -- --no-reboot --build-on-remote --flake "github:SymphonySimper/.dotfiles#${profile}" "nixos@${ip_addr}"

sudo nixos-enter --root /mnt -c 'su symph'
