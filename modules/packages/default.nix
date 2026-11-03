{ inputs, systems, ... }:
let
  inherit (inputs) nixpkgs;

  forAllSystems = nixpkgs.lib.genAttrs systems;
in
forAllSystems (
  system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
  {
    bentopdf = pkgs.callPackage ./bentopdf.nix { };
    ocr = pkgs.callPackage ./ocr.nix { };
    vidconv = pkgs.callPackage ./vidconv.nix { };
  }
)
