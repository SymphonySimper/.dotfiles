{ config, pkgs, ... }:
{
  imports = [
    ./helix.nix
    ./nvim.nix
  ];
}
