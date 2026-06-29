{ inputs, ... }: {
  flake-file.inputs = {
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.schema.user =
    {
      host,
      config,
      lib,
      ...
    }:
    {
      options.theme = {
        dark = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable dark mode theme rendering.";
        };

        flavors = {
          light = lib.mkOption {
            type = lib.types.str;
            default = "latte";
            description = "Catppuccin flavor for light mode profiles.";
          };
          dark = lib.mkOption {
            type = lib.types.str;
            default = "mocha";
            description = "Catppuccin flavor for dark mode profiles.";
          };
        };

        accent = lib.mkOption {
          type = lib.types.str;
          default = "mauve";
          description = "The primary color highlight accent.";
        };

        # Read-only attributes evaluated dynamically based on toggles
        flavor = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          description = "Calculated active Catppuccin flavor state.";
        };

        altFlavor = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          description = "Calculated inactive Catppuccin flavor state.";
        };

        color = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                hex = lib.mkOption { type = lib.types.str; };
                hsl = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
                rgb = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
              };
            }
          );
          readOnly = true;
          description = "Fully resolved color maps fetched straight from the theme palette asset.";
        };

        wallpaper = lib.mkOption {
          type = lib.types.str;
          default = "file://${../../assets/images/wallpaper.png}"; # Cleaned relative file reference
          description = "Absolute reference URI to user background wallpaper assets.";
        };

        font = {
          mono = lib.mkOption {
            type = lib.types.str;
            default = "JetBrainsMono Nerd Font";
            description = "The preferred user monospace typeface family.";
          };
        };
      };

      ## 2. COMPUTE DYNAMIC VALUES (Lazy Evaluation Pipeline)
      config.theme =
        let
          cfg = config.theme;

          mkConvertToString = set: builtins.mapAttrs (_: value: toString value) set;

          paletteFile = "${inputs.catppuccin.packages.${host.system}.palette}/palette.json";
          paletteData = builtins.fromJSON (builtins.readFile paletteFile);
        in
        {
          # Dynamically select flavor maps based on dark tracking flag state
          flavor = if cfg.dark then cfg.flavors.dark else cfg.flavors.light;
          altFlavor = if cfg.dark then cfg.flavors.light else cfg.flavors.dark;

          # Safely unpack the parsed string color data
          color = builtins.mapAttrs (_: value: {
            hex = value.hex;
            hsl = mkConvertToString value.hsl;
            rgb = mkConvertToString value.rgb;
          }) paletteData.${cfg.flavor}.colors;
        };
    };

  # Den injects the 'host' and 'user' records right here at the top level
  den.aspects.theme = { user, host, ... }: {
    homeManager = { pkgs, lib, ... }: {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      config = lib.mkMerge [
        {
          # 1. ALWAYS ACTIVE (Headless/Base)
          catppuccin = {
            enable = true;
            autoEnable = true;
            flavor = user.theme.flavor or "mocha";
            accent = user.theme.accent or "lavender";
          };
        }

        # 2. CONDITIONAL GRAPHICAL CONFIGURATION
        # Look Ma, no custom options! We read the 'host' argument directly from the outer function scope.
        (lib.mkIf (host.gui or false) {
          home.packages = with pkgs; [
            noto-fonts-cjk-sans

            (
              let
                variants = builtins.concatStringsSep "\\|" [
                  "Regular"
                  "Italic"
                  "Bold.*"
                ];
              in
              nerd-fonts.jetbrains-mono.overrideAttrs (old: {
                preInstall = ''
                  find . -type f -not -regex ".*JetBrainsMonoNerdFont-\(${variants}\).ttf" -delete
                '';
              })
            )
          ];

          dconf = {
            enable = true;
            settings."org/gnome/desktop/interface" = {
              color-scheme = if (user.theme.dark or true) then "prefer-dark" else "default";
            };
          };
        })
      ];
    };
  };
}
