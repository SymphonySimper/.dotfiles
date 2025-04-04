{
  description = "Home Manager configuration of symph";

  inputs = {
    # packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # common
    catppuccin.url = "github:catppuccin/nix";
    systems.url = "github:nix-systems/default";

    # system
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/nixos-wsl";

    # home
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:helix-editor/helix";
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      flake = import ./modules/flake { inherit inputs; };
    in
    {
      homeConfigurations = flake.profiles.home;
      nixosConfigurations = flake.profiles.system;
      devShells = flake.devShells;

      templates = flake.templates;
      defaultTemplate = self.templates.default;
    };
}
