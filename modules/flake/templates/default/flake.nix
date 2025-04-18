{
  # TODO: Change description
  description = "Template for Nix dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { ... }@inputs:
    let
      forAllSystems =
        f:
        inputs.nixpkgs.lib.genAttrs (import inputs.systems) (
          system:
          f {
            pkgs = import inputs.nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forAllSystems (
        { pkgs }:
        {
          default = pkgs.mkShell {
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
              just # do not remove

              # replace with packages that you need in env
              cowsay
            ];

            shellHook = # sh
              ''
                echo "Hello from Nix!"
              '';
          };
        }
      );
    };
}
