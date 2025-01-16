{ inputs, lib, ... }:
rec {
  mkGetDefault = import ./mkGetDefault.nix { inherit lib; };
  mkPkgs = import ./mkPkgs.nix { inherit inputs; };
  mkReadDir = import ./mkReadDir.nix { inherit lib mkGetDefault; };
}
