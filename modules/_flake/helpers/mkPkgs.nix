{ inputs, ... }:
let
  mkPkgs =
    {
      system,
      overlays ? [ ],
      forHome,
    }:
    let
      cfg = {
        inherit system;
        inherit overlays;
        config.allowUnfree = true;
      };
    in
    if forHome then import inputs.nixpkgs-unstable cfg else import inputs.nixpkgs-nixos-unstable cfg;
in
mkPkgs
