{ inputs, ... }:
let
  specialArgs = {
    inherit inputs;
    inherit (inputs) self;
  };

  mkNixos =
    path: system:
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs system;
      modules = [
        ../nixos
        path
      ];
    };

  mkHome =
    path: system:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = specialArgs;
      modules = [
        ../home
        path
      ];
    };
in
{
  nixosConfigurations = {
    laptop = mkNixos ./laptop/nixos.nix "x86_64-linux";
  };

  homeConfigurations = {
    laptop = mkHome ./laptop/home.nix "x86_64-linux";
  };
}
