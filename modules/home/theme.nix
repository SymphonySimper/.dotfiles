{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.theme;
in
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  options.my.theme = {
    enable = lib.mkEnableOption "Theme" // {
      default = true;
    };

    light = lib.mkEnableOption "Light mode" // {
      default = true;
    };

    flavors = {
      light = lib.mkOption {
        type = lib.types.str;
        description = "Flavor used in light mode";
        default = "latte";
      };
      dark = lib.mkOption {
        type = lib.types.str;
        description = "Flavor used in dark mode";
        default = "mocha";
      };
    };

    accent = lib.mkOption {
      type = lib.types.str;
      description = "Accent color";
      default = "mauve";
    };

    flavor = lib.mkOption {
      readOnly = true;
      type = lib.types.str;
      description = "Active flavor";
      default = cfg.flavors.${if cfg.light then "light" else "dark"};
    };
    altFlavor = lib.mkOption {
      readOnly = true;
      type = lib.types.str;
      description = "Inactive flavor";
      default = cfg.flavors.${if cfg.light then "dark" else "light"};
    };

    color = lib.mkOption {
      readOnly = true;
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hex = lib.mkOption { type = lib.types.str; };
            hsl = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
            rgb = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
          };
        }
      );
      default =
        let
          mkConvertToString = set: builtins.mapAttrs (_: value: toString value) set;
        in
        builtins.mapAttrs
          (_: value: {
            hex = value.hex;
            hsl = mkConvertToString value.hsl;
            rgb = mkConvertToString value.rgb;
          })
          (builtins.fromJSON (
            builtins.readFile "${
              inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.palette
            }/palette.json"
          )).${cfg.flavor}.colors;
    };

    font = {
      enable = lib.mkEnableOption "Enable font theme";
      mono = lib.mkOption {
        type = lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Mono font name";
            };
            package = lib.mkOption {
              type = lib.types.package;
              description = "Mono font package";
            };
          };
        };
        default = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono.overrideAttrs {
            # refer: https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerd-fonts/default.nix#L65
            preInstall = ''
              find . -type f -not -regex ".*JetBrainsMonoNerdFont-\(Regular\\|Italic\\|Bold.*\).ttf" -delete
            '';
          };
        };
      };
    };

    gtk.enable = lib.mkEnableOption "Enable GTK theme";
  };

  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = true;
      autoEnable = true;
      flavor = cfg.flavor;
      accent = cfg.accent;
    };

    _module.args = {
      mkGetTheme =
        {
          name,
          package ? null,
          returnName ? true,
        }:
        let
          formatKeys = {
            name = "%name%";
            flavor = "%flavor%";
            accent = "%accent%";
          };

          mkCapitalize =
            key: value:
            let

              capitalize = if lib.strings.hasInfix key name then false else true;
            in
            if capitalize then
              {
                key = lib.strings.toUpper key;
                value = lib.strings.toSentenceCase value;
              }
            else
              {
                inherit key value;
              };

          format = [
            (mkCapitalize formatKeys.name "catppuccin")
            (mkCapitalize formatKeys.flavor cfg.flavor)
            (mkCapitalize formatKeys.accent cfg.accent)
          ];

          formattedName = builtins.replaceStrings (map (f: f.key) format) (map (f: f.value) format) name;
          output =
            if package != null then
              "${inputs.catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.${package}}/${formattedName}"
            else
              formattedName;
        in
        if returnName then output else (builtins.readFile output);
    };

    home.packages = lib.mkIf cfg.font.enable [
      pkgs.noto-fonts-cjk-sans
      cfg.font.mono.package
    ];

    dconf = lib.mkIf cfg.gtk.enable {
      enable = true;

      settings."org/gnome/desktop/interface" = {
        color-scheme = if cfg.light then "default" else "prefer-dark";
      };
    };
  };
}
