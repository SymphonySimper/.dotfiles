{
  description = "Home Manager configuration of symph";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    # helix-flake.url = "github:helix-editor/helix";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      profileSettings = {
        name = "wsl";
        system = "x86_64-linux";
      };
      userSettings = {
        username = "symph";
      };
      lib = nixpkgs.lib;

      mkHome = { profile, system, }: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./profiles/${profile}/home.nix ];

        extraSpecialArgs = {
          inherit userSettings;
          inherit profileSettings;
          inherit inputs;
        };
      };

      mkSystem = { profile, system }: lib.nixosSystem {
        system = system;
        modules = [ ./profiles/${profile}/configuration.nix ];
        specialArgs = {
          # pass config variables from above
          inherit (nixpkgs.legacyPackages.${system}) pkgs;
          inherit userSettings;
          inherit profileSettings;
          inherit inputs;
        };
      };

      profiles = rec {
        default = {
          profile = "default";
          system = "x86_64-linux";
        };
        wsl = {
          profile = "wsl";
          system = default.system;
        };
      };
    in
    {
      homeConfigurations = {
        default = mkHome profiles.default;
        wsl = mkHome profiles.wsl;
      };

      nixosConfigurations = {
        wsl = mkSystem profiles.wsl;
      };
    };
}
