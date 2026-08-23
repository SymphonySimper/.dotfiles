{
  description = "NixOS and Home Manager configuration of SymphonySimper";

  inputs = {
    # packages
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    gnome-shell-extensions = {
      url = "git+https://github.com/SymphonySimper/gnome-shell-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # system
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:helix-editor/helix";
    # helix.url = "github:SymphonySimper/fork-helix";
    schemastore = {
      url = "github:SchemaStore/schemastore";
      flake = false;
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
    { ... }@inputs:
    let
      hosts = import ./modules/hosts { inherit inputs; };
    in
    {
      inherit (hosts) homeConfigurations nixosConfigurations;
      lib = { inherit (hosts) mkConfig; };

      templates = import ./modules/templates;
    };
}
