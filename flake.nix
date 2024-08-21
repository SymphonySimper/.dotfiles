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

    # Neovim plugins
    nvim-harpoon = {
      url = "github:ThePrimeagen/harpoon/harpoon2";
      flake = false;
    };
    nvim-lazygit = {
      url = "github:kdheepak/lazygit.nvim";
      flake = false;
    };
    nvim-mini = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    nvim-cmp-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    nvim-cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    nvim-cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    nvim-luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    nvim-cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    nvim-conform = {
      url = "github:stevearc/conform.nvim";
      flake = false;
    };
    nvim-trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
    nvim-ts-comments = {
      url = "github:folke/ts-comments.nvim";
      flake = false;
    };
    nvim-colorizer = {
      url = "github:NvChad/nvim-colorizer.lua";
      flake = false;
    };
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    nvim-markview = {
      url = "github:OXY2DEV/markview.nvim";
      flake = false;
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

      mkMyUtils = { pkgs }: (import ./utils/default.nix { inherit pkgs; });

      mkPkgs =
        {
          system,
          overlays ? [ ],
        }:
        (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = overlays;
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
            system = system;
            overlays = [
              (import ./overlays/nvim-plugins.nix { inherit inputs; })
              inputs.neorg-overlay.overlays.default
            ];
          };
          modules = [ ./profiles/${profile}/home.nix ];
          extraSpecialArgs = {
            inherit userSettings;
            inherit profileSettings;
            inherit inputs;
            myUtils = mkMyUtils { inherit pkgs; };
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
        lib.nixosSystem rec {
          inherit system;
          pkgs = mkPkgs { inherit system; };
          modules = [ ./profiles/${profile}/configuration.nix ];
          specialArgs = {
            inherit userSettings;
            inherit profileSettings;
            inherit inputs;
            myUtils = mkMyUtils { inherit pkgs; };
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
