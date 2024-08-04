#!/usr/bin/env bash
case "$1" in
flash)
  shift
  sudo dd if="$1" of="$2" bs=4096 conv=fsync status=progress
  ;;
*)
  nix build .#nixosConfigurations.pi.config.system.build.sdImage --show-trace
  ;;
esac
