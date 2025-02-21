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
  builtins.listToAttrs (
    builtins.map
      (
        name:
        let
          content = (import (./. + "/${name}") { inherit pkgs lib; });

          buildInputs = (helpers.mkGetDefault content "buildInputs" [ ]) ++ [
            pkgs.bashInteractive
          ];
          packages = helpers.mkGetDefault content "packages" [ ];
          shellHook = helpers.mkGetDefault content "shellHook" '''';
          env = helpers.mkGetDefault content "env" { };
        in
        {
          name = builtins.elemAt (builtins.match "(.*)\.nix" name) 0;
          value = pkgs.mkShell (
            {
              inherit buildInputs packages shellHook;
            }
            // env
          );
        }
      )
      (
        helpers.mkReadDir {
          path = ./.;
          type = "nix";
          ignoreDefault = true;
        }
      )
  )
)
