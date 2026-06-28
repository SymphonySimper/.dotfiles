{ lib, ... }:
{
  imports = [
    ./nix.nix
  ];

  options.my.isHome = lib.mkEnableOption "Is Home";
}
