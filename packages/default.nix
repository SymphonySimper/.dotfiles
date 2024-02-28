{ config, pkgs, ... }:
{
  imports = [
    ./dev/default.nix
    ./editor/default.nix
    ./cli.nix
    ./misc.nix
    ./git.nix
  ];
}
