{ config, pkgs, ... }:
{
  imports = [
    ./dev/default.nix
    ./editor/default.nix
    ./cli.nix
  ];
}
