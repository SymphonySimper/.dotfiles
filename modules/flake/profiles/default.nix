{
  inputs,
  lib,
  helpers,
  ...
}:
let
  mkGetDefault = helpers.mkGetDefault;

  mkMy =
    {
      profile ? { },
    }:
    let
      passedProfile = profile;
    in
    rec {
      name = mkGetDefault passedProfile "user.name" "symph";
      fullName = mkGetDefault passedProfile "user.fullName" "SymphonySimper";

      dir = {
        home = mkGetDefault passedProfile "dir.home" "/home/${name}";
        runBin = "/run/current-system/sw/bin";
      };

      profile = mkGetDefault passedProfile "name" "default";
      system = mkGetDefault passedProfile "system" "x86_64-linux";
      nixos = mkGetDefault passedProfile "nixos" false;
    };

  profileDir = ../../../profiles;

  mkProfilePath =
    dir: file:
    lib.path.append profileDir (
      lib.path.subpath.join [
        dir
        file
      ]
    );

  mkGetProfileDirs = helpers.mkReadDir {
    dirPath = profileDir;
    type = "dir";
  };

  mkProfile =
    {
      name,
      profile ? { },
      for, # system or home
    }:
    let
      forHome = for == "home";

      my = mkMy {
        profile = profile // {
          inherit name;
        };
      };

      pkgs = helpers.mkPkgs {
        system = my.system;
        overlays = [
          (import ../overlays/lib { inherit my inputs helpers; })
        ]
        ++ (lib.optionals forHome [ ]);
      };

      modules = [
        (profileDir + "/${my.profile}/${for}.nix")
      ]
      ++ (lib.optionals forHome [ ../../home ])
      ++ (lib.optionals (!forHome) [ ../../system ]);

      specialArgs = {
        inherit my;
        inherit inputs;
      };
    in
    if forHome then
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

      systemFile = mkProfilePath dir "system.nix";
      homeFile = mkProfilePath dir "home.nix";
    in
    (map
      (for: {
        inherit name;
        inherit for;
        profile = {
          nixos = builtins.pathExists systemFile;
        };
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
      map (
        profile:
        if profile.for == for then
          rec {
            name = profile.name;
            value = mkProfile {
              inherit for;
              inherit name;
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
