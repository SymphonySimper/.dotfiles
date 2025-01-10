{
  inputs,
  lib,
  mkGetDefault,
  mkMy,
  mkPkgs,
  ...
}:
let
  profileDir = ../profiles;

  mkProfilePath =
    dir: file:
    lib.path.append profileDir (
      lib.path.subpath.join [
        dir
        file
      ]
    );
  mkGetProfileDirs = builtins.attrNames (
    lib.attrsets.filterAttrs (name: value: value == "directory") (builtins.readDir profileDir)
  );

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

      pkgs = mkPkgs {
        system = my.system;
        overlays =
          [
            (import ./overlays/lib.nix { inherit my; })
          ]
          ++ (lib.optionals (for == "home") [
            # (import ./overlays/nvim-plugins.nix { inherit inputs; })
          ]);
      };

      modules =
        [
          (profileDir + "/${my.profile}/${for}.nix")
        ]
        ++ (lib.optionals (for == "home") [
          inputs.chaotic.homeManagerModules.default
          inputs.nixvim.homeManagerModules.nixvim
          inputs.catppuccin.homeManagerModules.catppuccin
        ])
        ++ (lib.optionals (for == "system") [
          inputs.chaotic.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
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

  profilesWithConfig = builtins.concatMap (
    dir:
    let
      name = dir;

      configFile = mkProfilePath dir "config.nix";
      systemFile = mkProfilePath dir "system.nix";
      homeFile = mkProfilePath dir "home.nix";

      config = if builtins.pathExists configFile then (import configFile) else { };
    in
    (builtins.map
      (for: {
        inherit name;
        inherit for;
        settings = mkGetDefault config "settings" { };
        profile = mkGetDefault config "profile" { };
      })
      (
        builtins.concatLists (
          (lib.optional (builtins.pathExists systemFile) [ "system" ])
          ++ (lib.optional (builtins.pathExists homeFile) [ "home" ])
        )
      )
    )
  ) mkGetProfileDirs;

  mkProfiles =
    for:
    let
      profiles = builtins.filter (profile: profile.for == for) profilesWithConfig;
    in
    builtins.listToAttrs (
      builtins.map (
        profile:
        if profile.for == for then
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
{
  home = mkProfiles "home";
  system = mkProfiles "system";
}
