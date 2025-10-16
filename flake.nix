{
  description = "NixOS and Home Manager configuration of SymphonySimper";

  inputs = {
    # packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # common
    systems.url = "github:nix-systems/default";
    catppuccin.url = "github:catppuccin/nix";

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
    # helix.url = "github:SymphonySimper/fork-helix";
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org?priority=1"
      "https://nix-community.cachix.org?priority=2"
      "https://catppuccin.cachix.org?priority=3"
      "https://helix.cachix.org?priority=4"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
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
