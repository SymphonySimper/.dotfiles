{
  # TODO: Change description
  description = "Template for Nix dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = (import inputs.systems);
      perSystem =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          # TODO: Update packages and shellHook
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [ cowsay ];
            shellHook = # sh
              ''cowsay "Hello from Nix!"'';
          };
        };
    };
}
