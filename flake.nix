{
  description = "Home Manager configuration of symph";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/nixos-wsl";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    # yazi.url = "github:sxyazi/yazi";
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    # helix-flake.url = "github:helix-editor/helix";

    # Neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        dirs = {
          lifeisfun = "lifeisfun";
          importantnt = "importantnt";
        };
        theme = {
          dark = false;
          flavor = if theme.dark then "mocha" else "latte";
          color = (import ./assets/colors.nix { flavor = theme.flavor; });
          gtk = if theme.dark then "Adwaita-dark" else "Adwaita";
          wallpaper = "${home}/.dotfiles/assets/images/bg.png";
        };
        font = {
          sans = "Poppins";
          mono = "JetBrainsMono Nerd Font";
          glyph = "Font Awesome 6 Free";
        };
        desktop = {
          name = "sway";
          wm = desktop.name != "gnome";
          steam = true;
        };
        programs = {
          terminal = "alacritty";
          editor = "nvim";
          multiplexer = "tmux";
          browser = "chromium";
          launcher = "wofi";
          notification = "dunst";
          video = "mpv";
          pdf = "zathura";
          image = "loupe";
        };
      };
      lib = nixpkgs.lib;

      mkPkgs =
        {
          system,
          overlays ? [ ],
        }:
        (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (import ./overlays/lib.nix)
          ] ++ overlays;
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
        home-manager.lib.homeManagerConfiguration rec {
          pkgs = mkPkgs {
            inherit system;
            overlays = [
              # (import ./overlays/nvim-plugins.nix { inherit inputs; })
            ];
          };
          lib = pkgs.lib;
          modules = [
            ./profiles/${profile}/home.nix
            inputs.nixvim.homeManagerModules.nixvim
          ];
          extraSpecialArgs = {
            inherit userSettings;
            inherit profileSettings;
            inherit inputs;
          };
        };

      mkSystem =
        { profile, system }:
        let
          profileSettings = mkProfileSettings {
            inherit profile;
            inherit system;
          };
        in
        lib.nixosSystem rec {
          inherit system;
          pkgs = mkPkgs { inherit system; };
          lib = pkgs.lib;
          modules = [ ./profiles/${profile}/configuration.nix ];
          specialArgs = {
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
