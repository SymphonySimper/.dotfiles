{ config, pkgs, ... }:
{
  imports = [
    ./js.nix
    ./python.nix
    ./rust.nix
  ];
}
