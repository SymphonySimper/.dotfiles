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

    # Neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    nvim-markview = {
      url = "github:OXY2DEV/markview.nvim";
      flake = false;
    };
    nvim-helpview = {
      url = "github:OXY2DEV/helpview.nvim";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;

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

      mkLib =
        { pkgs }:
        pkgs.lib.extend (final: prev: { my = import ./modules/common/lib/default.nix { inherit pkgs; }; });

      mkImportExists = { path }: if builtins.pathExists path then [ path ] else [ ];

      mkSettingsFile =
        { profile }:
        let
          path = ./profiles/${profile}/settings.nix;
        in
        (mkImportExists { inherit path; });

      mkHome =
        { profile, system }:
        home-manager.lib.homeManagerConfiguration rec {
          pkgs = mkPkgs {
            inherit system;
            overlays = [
              (import ./overlays/nvim-plugins.nix { inherit inputs; })
              inputs.nvim-neorg-overlay.overlays.default
            ];
          };
          lib = mkLib { inherit pkgs; };
          modules =
            [
              inputs.nixvim.homeManagerModules.nixvim
              ./modules/common/default.nix
            ]
            ++ (mkSettingsFile { inherit profile; })
            ++ [

              ./modules/home/default.nix
            ]
            ++ (mkImportExists { path = ./profiles/${profile}/home.nix; });
          extraSpecialArgs = {
            inherit inputs;
          };
        };

      mkSystem =
        { profile, system }:
        lib.nixosSystem {
          inherit system;
          pkgs = mkPkgs { system = system; };
          modules = [
            ./modules/common/default.nix
            ./modules/system/default.nix
            ./profiles/${profile}/configuration.nix
          ] ++ (mkSettingsFile { inherit profile; });
          specialArgs = {
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
