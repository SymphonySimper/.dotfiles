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
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;

      mkGetDefault =
        attr: key: default:
        let
          path = lib.strings.splitString "." key;
        in
        if lib.attrsets.hasAttrByPath path attr then lib.attrsets.getAttrFromPath path attr else default;
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
          gui = {
            enable = mkGetDefault settings "gui.enable" false;
            desktop = {
              enable = mkGetDefault settings "gui.desktop.enable" false;
              type = mkGetDefault settings "gui.desktop.type" "wm"; # wm or de
              wm = gui.desktop.type == "wm";
            };
            display = {
              name = mkGetDefault settings "gui.display.name" "eDP-1";
              scale = mkGetDefault settings "gui.display.scale" 1;
              width = mkGetDefault settings "gui.display.width" 1920;
              height = mkGetDefault settings "gui.display.height" 1080;
              refreshRate = mkGetDefault settings "gui.display.refreshRate" 60;
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

      mkPkgs =
        {
          my,
          overlays ? [ ],
        }:
        (import nixpkgs {
          system = my.system;
          config.allowUnfree = true;
          overlays = [
            (import ./overlays/lib.nix { inherit my; })
          ] ++ overlays;
        });

      mkHome =
        {
          settings ? { },
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
            inherit my;
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
          settings ? { },
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
          pkgs = mkPkgs { inherit my; };
          lib = pkgs.lib;
          modules = [ ./profiles/${my.profile}/system.nix ];
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
