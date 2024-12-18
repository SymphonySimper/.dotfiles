{
  pkgs,
  lib,
  config,
  inputs,
  my,
  ...
}:
let
  frequency = "weekly";
  system = config.my.common.system;

  unsafeMkIf = condition: content: if condition then content else { };
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

          (unsafeMkIf system {
            dates = frequency;
          })

          (unsafeMkIf (!system) {
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

            substituters = [
              "https://nix-community.cachix.org/"
            ];

            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];

            # Enable flakse
            experimental-features = [
              "nix-command"
              "flakes"
            ];
          }
        ];
      }

      (unsafeMkIf (system) {
        # Strage optimisation
        optimise.automatic = true;
      })
    ];
  };
}
