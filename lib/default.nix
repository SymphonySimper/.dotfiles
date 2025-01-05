{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
in
rec {
  templates = import ./templates;
  helpers = import ./helpers {
    inherit inputs;
    inherit lib;
  };
  profiles = import ./profiles.nix {
    inherit inputs;
    inherit lib;
    mkGetDefault = helpers.mkGetDefault;
    mkMy = helpers.mkMy;
    mkPkgs = helpers.mkPkgs;
  };
}
