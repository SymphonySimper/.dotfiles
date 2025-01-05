{
  description = "Home Manager configuration of symph";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/nixos-wsl";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    systems.url = "github:nix-systems/default";

    # Neovim
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
