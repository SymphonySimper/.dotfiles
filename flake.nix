{
  description = "Home Manager configuration of symph";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # helix-flake.url = "github:helix-editor/helix";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      profileSettings = {
        name = "wsl";
        system = "x86_64-linux";
      };
      userSettings = rec {
        username = "symph";
        description = "SymphonySimper";
        home = "/home/${username}";
        wallpaper = "${home}/.dotfiles/assets/images/bg.png";
        font = {
          sans = "Poppins";
          mono = "JetBrainsMono Nerd Font";
          glyph = "Font Awesome 6 Free";
        };
        programs = {
          zellij = true;
          wm = true;
          terminal = "foot";
          browser = "chromium";
          appLauncher = ".wofi-wrapped";
          notification = ".dunst-wrapped";
          wallpaper = "swaybg -i ${wallpaper} -m fill";
        };
      };
      lib = nixpkgs.lib;
      myUtils = import ./utils/default.nix;

      mkPkgs =
        { system }:
        (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });

      mkHome =
        { profile, system }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs { system = system; };
          modules = [
            ./profiles/${profile}/home.nix
            inputs.nixvim.homeManagerModules.nixvim
          ];
          extraSpecialArgs = {
            inherit userSettings;
            inherit profileSettings;
            inherit inputs;
            inherit myUtils;
          };
        };

      mkSystem =
        { profile, system }:
        lib.nixosSystem {
          system = system;
          pkgs = mkPkgs { system = system; };
          modules = [ ./profiles/${profile}/configuration.nix ];
          specialArgs = {
            inherit userSettings;
            inherit profileSettings;
            inherit inputs;
            inherit myUtils;
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
        gui = {
          profile = "gui";
          system = default.system;
        };
      };
    in
    {
      homeConfigurations = {
        default = mkHome profiles.default;
        wsl = mkHome profiles.wsl;
        gui = mkHome profiles.gui;
      };

      nixosConfigurations = {
        wsl = mkSystem profiles.wsl;
        gui = mkSystem profiles.gui;
      };
    };
}
