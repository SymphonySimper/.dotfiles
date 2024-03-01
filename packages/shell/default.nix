{ config, pkgs, ... }:
{
  imports = [
    ./env.nix
    ./starship.nix
    ./zsh.nix
  ];
}
