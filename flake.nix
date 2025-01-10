{
  description = "Home Manager configuration of symph";

  inputs = {
    # packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # common
    catppuccin.url = "github:catppuccin/nix";
    systems.url = "github:nix-systems/default";

    # system
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nix-gaming.url = "github:fufexan/nix-gaming";

    # home
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      myLib = import ./lib { inherit inputs; };
    in
    {
      homeConfigurations = myLib.profiles.home;
      nixosConfigurations = myLib.profiles.system;
      templates = myLib.templates;
      devShells = (
        import ./lib/devshell {
          inherit inputs;
          inherit myLib;
        }
      );
    };
}
