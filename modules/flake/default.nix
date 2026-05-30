{ inputs, ... }:
let
  lib = inputs.nixpkgs-nixos-unstable.lib;
in
rec {
  helpers = import ./helpers { inherit inputs lib; };
  profiles = import ./profiles { inherit inputs lib helpers; };

  templates = import ./templates { inherit helpers; };
}
