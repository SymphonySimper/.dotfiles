{ inputs, lib, ... }:
{
  mkGetColor = import ./mkGetColor.nix;
  mkGetDefault = import ./mkGetDefault.nix { inherit lib; };
  mkMy = import ./mkMy.nix { inherit lib; };
  mkPkgs = import ./mkPkgs.nix { inherit inputs; };
}
