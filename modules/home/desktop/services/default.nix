{ lib, ... }:
{
  imports = lib.my.mkReadDir {
    path = ./.;
    type = "nix";
    asPath = true;
    ignoreDefault = true;
  };
}
