{ inputs, myLib, ... }:
let
  eachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
in
eachSystem (
  system:
  let
    pkgs = myLib.helpers.mkPkgs {
      inherit system;
    };
    lib = pkgs.lib;
  in
  {
    python = import ./python.nix {
      inherit pkgs;
    };
  }
)
