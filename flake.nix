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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # yazi.url = "github:sxyazi/yazi";
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    # helix-flake.url = "github:helix-editor/helix";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      userSettings = rec {
        name = {
          user = "symph";
          name = "SymphonySimper";
        };
        home = "/home/${name.user}";
        wallpaper = "${home}/.dotfiles/assets/images/bg.png";
        dirs = {
          lifeisfun = "lifeisfun";
          importantnt = "importantnt";
        };
        theme = {
          dark = false;
          flavor = if theme.dark then "mocha" else "latte";
          color = (import ./assets/colors.nix { flavor = theme.flavor; });
          gtk = if theme.dark then "Adwaita-dark" else "Adwaita";
        };
        font = {
          sans = "Poppins";
          mono = "JetBrainsMono Nerd Font";
          glyph = "Font Awesome 6 Free";
        };
        desktop = {
          name = "sway";
          wm = desktop.name != "gnome";
        };
        programs = {
          terminal = "alacritty";
          editor = "nvim";
          multiplexer = "tmux";
          browser = "chromium";
          launcher = "wofi";
          notification = "dunst";
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
          overlays = [ inputs.neorg-overlay.overlays.default ];
        });

      mkProfileSettings =
        { profile, system }:
        {
          inherit profile;
          inherit system;
        };

      mkHome =
        { profile, system }:
        let
          profileSettings = mkProfileSettings {
            inherit profile;
            inherit system;
          };
        in
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
        let
          profileSettings = {
            inherit profile;
            inherit system;
          };
        in
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
        pi = {
          profile = "pi";
          system = "aarch64-linux";
        };
      };
    in
    {
      homeConfigurations = {
        default = mkHome profiles.default;
        wsl = mkHome profiles.wsl;
        gui = mkHome profiles.gui;
        pi = mkHome profiles.pi;
      };

      nixosConfigurations = {
        wsl = mkSystem profiles.wsl;
        gui = mkSystem profiles.gui;
        pi = mkSystem profiles.pi;
      };
    };
}
