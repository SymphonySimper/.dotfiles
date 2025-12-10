{
  inputs,
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  system = config.my.common.system;
in
{
  options.my.common = {
    system = lib.mkOption {
      type = lib.types.bool;
    };
  };
  config = {
    nix = lib.mkMerge [
      {
        package = pkgs.nix;

        # Path for pkgs
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        # Garbage Collection
        gc = {
          automatic = true;
          options = "--delete-older-than 14d";
          dates = "weekly";
        };

        settings = lib.mkMerge [
          {
            show-trace = true;
            auto-optimise-store = true;
            trusted-users = [
              "root"
              my.name
            ];

            # Enable flakes
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            commit-lock-file-summary = "chore(flake): update flake.lock";
          }

          (lib.attrsets.optionalAttrs system {
            extra-platforms = config.boot.binfmt.emulatedSystems;
          })
        ];

        registry = {
          nixpkgs.flake = inputs.nixpkgs;
          my.flake = inputs.self;
        };
      }
    ];
  };
}
