{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in
rec {
  mkGetColor = import ./mkGetColor.nix;
  mkGetDefault = import ./mkGetDefault.nix { inherit lib; };
  mkMy = import ./mkMy.nix { inherit lib; };
  mkProfiles = import ./mkProfiles.nix {
    inherit inputs;
    inherit lib;
    inherit mkGetDefault;
    inherit mkMy;
  };
}
