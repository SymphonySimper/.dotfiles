{
  inputs,
  lib,
  mkGetDefault,
  mkMy,
  ...
}:
let

  mkProfile =
    {
      name,
      settings ? { },
      profile ? { },
      for, # system or home
    }:
    let
      my = mkMy {
        inherit settings;
        profile = profile // {
          inherit name;
        };
      };

      pkgs = import inputs.nixpkgs {
        system = my.system;
        config.allowUnfree = true;
        overlays =
          [
            (import ../overlays/lib.nix { inherit my; })
          ]
          ++ (lib.optionals (for == "home") [
            # (import ./overlays/nvim-plugins.nix { inherit inputs; })
          ]);
      };

      modules =
        [
          ../../profiles/${my.profile}/${for}.nix
        ]
        ++ (lib.optionals (for == "home") [
          inputs.nixvim.homeManagerModules.nixvim
        ]);

      specialArgs = {
        inherit my;
        inherit inputs;
      };
    in
    if for == "home" then
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        inherit modules;
        lib = pkgs.lib;
        extraSpecialArgs = specialArgs;
      }
    else
      lib.nixosSystem {
        inherit pkgs;
        inherit modules;
        inherit specialArgs;
        lib = pkgs.lib;
        system = my.system;
      };

  mkProfiles =
    profiles: for:
    builtins.listToAttrs (
      map (
        profile:
        if builtins.elem for profile.for then
          rec {
            name = profile.name;
            value = mkProfile {
              inherit for;
              inherit name;
              settings = profile.settings;
              profile = mkGetDefault profile "profile" { };
            };
          }
        else
          null

      ) profiles
    );

in
mkProfiles
