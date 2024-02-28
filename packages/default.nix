{ config, pkgs, ... }:
{
  imports = [
    ./misc.nix
    ./dev/default.nix
    ./editor/default.nix
    ./cli/default.nix
  ];
}
