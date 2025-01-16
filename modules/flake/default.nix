{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in
rec {
  helpers = import ./helpers { inherit inputs lib; };
  profiles = import ./profiles {
    inherit inputs lib;
    mkGetDefault = helpers.mkGetDefault;
    mkPkgs = helpers.mkPkgs;
  };

  templates = import ./templates;
  devShells = import ./devshell { inherit inputs helpers; };
}
