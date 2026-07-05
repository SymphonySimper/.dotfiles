{ inputs, den, ... }:
{
  flake-file = {
    inputs.catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixConfig = {
      extra-substituters = [ "https://catppuccin.cachix.org?priority=3" ];
      extra-trusted-public-keys = [
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      ];
    };
  };

  den.default.includes = [ den.aspects.theme ];

  den.aspects.theme = {
    homeManager =
      {
        inputs',
        config,
        lib,
        ...
      }:
      let
        cfg = config.theme;
      in
      {
        imports = [ inputs.catppuccin.homeModules.catppuccin ];

        options.theme = {
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
            description = "Active flavor pallete";
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
                (builtins.fromJSON (builtins.readFile "${inputs'.catppuccin.packages.palette}/palette.json"))
                .${cfg.flavor}.colors;
          };
        };

        config = {
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
                    "${inputs'.catppuccin.packages.${package}}/${formattedName}"
                  else
                    formattedName;
              in
              if returnName then output else (builtins.readFile output);
          };
        };
      };
  };
}
