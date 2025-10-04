{ lib, ... }:
{
  imports = lib.my.mkReadDir {
    path = ./.;
    asPath = true;
    type = "nix";
    ignoreDefault = true;
  };
}
