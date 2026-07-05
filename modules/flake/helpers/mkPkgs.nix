{ inputs, ... }:
let
  mkPkgs =
    {
      system,
      overlays ? [ ],
    }:
    import inputs.nixpkgs {
      inherit system;
      inherit overlays;
      config.allowUnfree = true;
    };
in
mkPkgs
