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

    nixpkgs-update = {
      url = "github:nix-community/nixpkgs-update";
    };

    catppuccin.url = "github:catppuccin/nix";

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
      profiles = [
        {
          name = "wsl";
          for = [
            "system"
            "home"
          ];
        }
        {
          name = "gui";
          for = [
            "system"
            "home"
          ];
          settings = {
            gui = {
              enable = true;
              desktop.enable = true;
              display = {
                name = "eDP-1";
                scale = 1.8;
                width = 2880;
                height = 1800;
                refreshRate = 60;
              };
            };
          };
        }
      ];
    in
    {
      homeConfigurations = myLib.helpers.mkProfiles profiles "home";
      nixosConfigurations = myLib.helpers.mkProfiles profiles "system";
      templates = myLib.templates;
    };
}
