{ config, pkgs, ... }:
{
  imports = [
    ./helix.nix
    ./nvim/default.nix
  ];
}
