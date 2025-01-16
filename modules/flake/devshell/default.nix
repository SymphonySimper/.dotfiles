{ inputs, helpers, ... }:
let
  eachSystem = inputs.nixpkgs.lib.genAttrs (import inputs.systems);
in
eachSystem (
  system:
  let
    pkgs = helpers.mkPkgs {
      inherit system;
    };
    lib = pkgs.lib;
  in
  {
    python = import ./python.nix { inherit pkgs; };
  }
)
