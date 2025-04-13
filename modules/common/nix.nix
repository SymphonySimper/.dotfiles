{
  inputs,
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  frequency = "weekly";
  system = config.my.common.system;

  mkUnsafeIf = condition: content: if condition then content else { };
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
        gc = lib.mkMerge [
          {
            automatic = true;
            options = "--delete-older-than 14d";
          }

          (mkUnsafeIf system {
            dates = frequency;
          })

          (mkUnsafeIf (!system) {
            inherit frequency;
          })
        ];

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
          }
        ];

        registry = {
          nixpkgs.flake = inputs.nixpkgs;
          my.flake = inputs.self;
        };
      }

      (mkUnsafeIf (system) {
        # Storage optimization
        optimise.automatic = true;
      })
    ];
  };
}
