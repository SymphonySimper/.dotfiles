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
      nixos = mkGetDefault passedProfile "nixos" false;

      gui = {
        enable = mkGetDefault settings "gui.enable" false;
        desktop.enable = mkGetDefault settings "gui.desktop.enable" false;

        display = rec {
          name = mkGetDefault settings "gui.display.name" "eDP-1";
          scale = mkGetDefault settings "gui.display.scale" 1;
          width = mkGetDefault settings "gui.display.width" 1920;
          height = mkGetDefault settings "gui.display.height" 1080;
          refreshRate = mkGetDefault settings "gui.display.refreshRate" 60;
          maxRefreshRate = mkGetDefault settings "gui.display.maxRefreshRate" refreshRate;
          vrr = mkGetDefault settings "gui.display.vrr" false;

          desktop = {
            width = width / scale;
            height = height / scale;
          };

          string = {
            scale = builtins.toString scale;
            width = builtins.toString width;
            height = builtins.toString height;
            refreshRate = builtins.toString refreshRate;
            maxRefreshRate = builtins.toString maxRefreshRate;

            desktop = {
              width = builtins.toString desktop.width;
              height = builtins.toString desktop.height;
            };
          };
        };
      };

      theme = {
        dark = mkGetDefault settings "theme.dark" false;

        flavors = {
          dark = "mocha";
          light = "latte";
        };

        flavor = builtins.getAttr (if theme.dark then "dark" else "light") theme.flavors;
        altFlavor = builtins.getAttr (if theme.dark then "light" else "dark") theme.flavors;

        # refer: https://github.com/catppuccin/palette/blob/main/palette.json
        color =
          builtins.mapAttrs (_: value: value.hex)
            (builtins.fromJSON (
              builtins.readFile "${inputs.catppuccin.packages.${system}.palette}/palette.json"
            )).${theme.flavor}.colors;

        gtk = if theme.dark then "Adwaita-dark" else "Adwaita";
        wallpaper = "${dir.home}/.dotfiles/modules/flake/assets/images/wallpaper.png";

        font = {
          sans = "Poppins";
          mono = "JetBrainsMono Nerd Font";
          glyph = "Font Awesome 6 Free";
        };
      };

      programs = (import ./programs.nix);
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
    path = profileDir;
    type = "dir";
  };

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

      pkgs = helpers.mkPkgs {
        system = my.system;
        overlays = [
          (import ../overlays/lib { inherit my helpers; })
        ] ++ (lib.optionals (for == "home") [ ]);
      };

      modules =
        [ (profileDir + "/${my.profile}/${for}.nix") ]
        ++ (lib.optionals (for == "home") [ ../../home ])
        ++ (lib.optionals (for == "system") [ ../../system ]);

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
        profile = (mkGetDefault config "profile" { }) // {
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
