{ config, pkgs, ... }:
{
  imports = [
    ./rust.nix
    ./js.nix
  ];
}
