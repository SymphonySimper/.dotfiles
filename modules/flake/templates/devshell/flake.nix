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
          devShells.default = pkgs.mkShell {
            # Uncomment if LD_LIBRARY_PATH is required
            # LD_LIBRARY_PATH = lib.makeLibraryPath (
            #   with pkgs;
            #   [
            #     stdenv.cc.cc
            #   ]
            # );

            buildInputs = [
              pkgs.bashInteractive # do not remove
            ];

            # TODO: Update packages and shellHook
            packages = with pkgs; [
              # replace with packages that you need in env
              cowsay
            ];

            shellHook = # sh
              ''
                echo "Hello from Nix!"
              '';
          };
        };
    };
}
