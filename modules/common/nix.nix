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

  caches = [
    {
      url = "https://cache.nixos.org";
      key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
      condition = (!system);
    }
    {
      url = "https://nix-community.cachix.org";
      key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      priority = 100;
    }
  ];

  mkCaches =
    type:
    lib.mkAfter (
      builtins.concatLists (
        builtins.map (
          cache:
          let
            condition =
              if builtins.hasAttr "condition" cache then (builtins.getAttr "condition" cache) else true;
            priority =
              if builtins.hasAttr "priority" cache then
                "?priority=${builtins.toString (builtins.getAttr "priority" cache)}"
              else
                "";

            value = if type == "url" then "${cache.${type}}${priority}" else cache.${type};
          in
          lib.lists.optionals condition [ value ]
        ) caches
      )
    );

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

            substituters = mkCaches "url";
            trusted-public-keys = mkCaches "key";

            # Enable flakes
            experimental-features = [
              "nix-command"
              "flakes"
            ];
          }
        ];
      }

      (mkUnsafeIf (system) {
        # Storage optimization
        optimise.automatic = true;
      })
    ];
  };
}
