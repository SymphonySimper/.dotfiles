{ inputs, lib, ... }:
{
  mkGetDefault = import ./mkGetDefault.nix { inherit lib; };
  mkPkgs = import ./mkPkgs.nix { inherit inputs; };
}
