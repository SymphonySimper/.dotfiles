{ config, pkgs, ... }:
{
  imports = [
    ./cli/default.nix
    ./dev/default.nix
    ./editor/default.nix
    ./misc.nix
    ./shell/default.nix
  ];
}
