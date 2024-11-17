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

    # yazi.url = "github:sxyazi/yazi";
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    # Neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      mkGetDefault =
        attr: key: default:
        if builtins.hasAttr key attr then attr.${key} else default;
      mkMy =
        {
          settings ? { },
          profile ? { },
        }:
        let
          passedProfile = profile;
        in
        rec {
          name = "symph";
          fullName = "SymphonySimper";
          dir = {
            home = "/home/${name}";
            dev = "${dir.home}/lifeisfun";
            data = "${dir.home}/importantnt";
          };
          profile = mkGetDefault passedProfile "name" "default";
          system = mkGetDefault passedProfile "system" "x86_64-linux";
          cli = {
            enable = mkGetDefault cli.enable true;
          };
          gui = {
            enable = mkGetDefault settings "gui.enable" false;
            desktop = {
              enable = mkGetDefault settings "gui.desktop.enable" false;
              type = mkGetDefault settings "gui.desktop.type" "wm"; # wm or de
              wm = gui.desktop.type == "wm";
            };
          };
          theme = {
            dark = mkGetDefault settings "theme.dark" false;
            flavor = if theme.dark then "mocha" else "latte";
            color = (import ./assets/colors.nix { flavor = theme.flavor; });
            gtk = if theme.dark then "Adwaita-dark" else "Adwaita";
            wallpaper = "${dir.home}/.dotfiles/assets/images/bg.png";

            font = {
              sans = "Poppins";
              mono = "JetBrainsMono Nerd Font";
              glyph = "Font Awesome 6 Free";
            };
          };
          programs = {
            terminal = "alacritty";
            editor = "nvim";
            multiplexer = "tmux";
            browser = "chromium";
            launcher = "wofi";
            notification = "dunst";
            music = "yt";
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

      mkHome =
        {
          settings,
          profile,
        }:
        let
          my = mkMy {
            inherit settings;
            inherit profile;
          };
        in
        home-manager.lib.homeManagerConfiguration rec {
          pkgs = mkPkgs {
            system = my.system;
            overlays = [
              # (import ./overlays/nvim-plugins.nix { inherit inputs; })
            ];
          };
          lib = pkgs.lib;
          modules = [
            ./profiles/${my.profile}/home.nix
            inputs.nixvim.homeManagerModules.nixvim
          ];
          extraSpecialArgs = {
            inherit my;
            inherit inputs;
          };
        };

      mkSystem =
        {
          settings,
          profile,
        }:
        let
          my = mkMy {
            inherit settings;
            inherit profile;
          };
        in
        lib.nixosSystem rec {
          system = my.system;
          pkgs = mkPkgs { system = my.system; };
          lib = pkgs.lib;
          modules = [ ./profiles/${my.profile}/configuration.nix ];
          specialArgs = {
            inherit my;
            inherit inputs;
          };
        };

      profiles = {
        wsl = {
          profile.name = "wsl";
        };
        gui = {
          profile.name = "gui";
          settings = {
            gui = {
              enable = true;
              desktop = {
                enable = true;
              };
            };
          };
        };
      };
    in
    {
      homeConfigurations = {
        wsl = mkHome profiles.wsl;
        gui = mkHome profiles.gui;
      };

      nixosConfigurations = {
        wsl = mkSystem profiles.wsl;
        gui = mkSystem profiles.gui;
      };
    };
}
