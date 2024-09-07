{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.my;

  mkDirectoryOption =
    {
      name,
      pathPrefix,
      description,
    }:
    lib.mkOption {
      inherit description;
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "${name} directory";
            type = lib.types.str;
            default = name;
            readOnly = true;
          };
          path = lib.mkOption {
            description = "Full path of ${name} directory";
            type = lib.types.str;
            default = "${pathPrefix}/${name}";
            readOnly = true;
          };
        };
      };
      default = { };
    };

  mkFontOption =
    {
      name,
      package,
      description,
    }:
    lib.mkOption {
      inherit description;
      readOnly = true;
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = name;
          };
          package = lib.mkOption {
            type = lib.types.package;
            default = package;
          };
        };
      };
      default = { };
    };
in
{
  options.my = {
    system = lib.mkOption {
      type = lib.types.str;
      description = "System architecture";
      default = pkgs.system;
      readOnly = true;
    };

    profile = lib.mkOption {
      type = lib.types.str;
      description = "Profile name";
      default = "default";
    };

    user = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "username";
            type = lib.types.str;
            default = "symph";
          };
          fullName = lib.mkOption {
            description = "fullname";
            type = lib.types.str;
            default = "SymphonySimper";
          };
        };
      };
      default = { };
    };

    directory = lib.mkOption {
      description = "Directories";
      type = lib.types.submodule {
        options = {
          home = mkDirectoryOption {
            name = cfg.user.name;
            pathPrefix = "/home";
            description = "Home directory";
          };
          dev = mkDirectoryOption {
            name = "lifeisfun";
            pathPrefix = cfg.directory.home.path;
            description = "Dev directory";
          };
          data = mkDirectoryOption {
            name = "importantnt";
            pathPrefix = cfg.directory.home.path;
            description = "Data directory";
          };
        };
      };
      default = { };
    };

    theme = lib.mkOption {
      description = "Settings related to theme";
      type = lib.types.submodule {
        options = {
          dark = lib.mkOption {
            description = "Enable dark mode. (default: false)";
            type = lib.types.bool;
            default = false;
          };
          flavor = lib.mkOption {
            description = "Catpuccin flavor";
            type = lib.types.str;
            readOnly = true;
            default = if cfg.theme.dark then "mocha" else "latte";
          };
          color = lib.mkOption {
            description = "Catpuccin flavor color";
            type = lib.types.attrsOf (lib.types.str);
            readOnly = true;
            default = (import ./colors.nix { flavor = cfg.theme.flavor; });
          };
          gtk = lib.mkOption {
            description = "GTK theme";
            type = lib.types.str;
            readOnly = true;
            default = if cfg.theme.dark then "Adwaita-dark" else "Adwaita";
          };
          wallpaper = lib.mkOption {
            description = "Wallpaper to use";
            type = lib.types.str;
            readOnly = true;
            default = "${cfg.directory.home.path}/.dotfiles/assets/images/bg.png";
          };

          font = lib.mkOption {
            description = "Fonts to use for sans, mono and glyph";
            type = lib.types.submodule {
              options = {
                sans = mkFontOption {
                  description = "Sans font";
                  name = "Poppins";
                  package = (pkgs.google-fonts.override { fonts = [ "Poppins" ]; });
                };
                mono = mkFontOption {
                  description = "Monospace font";
                  name = "JetBrainsMono Nerd Font";
                  package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
                };
                glyph = mkFontOption {
                  description = "Glyph font";
                  name = "Font Awesome 6 Free";
                  package = pkgs.font-awesome;
                };
              };
            };
            default = { };
          };
        };
      };
      default = { };
    };

    gui = lib.mkOption {
      description = "Settings related to gui";
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "gui";
          display = lib.mkOption {
            description = "Display settings";
            type = lib.types.submodule {
              options = {
                width = lib.mkOption {
                  description = "Display width";
                  type = lib.types.ints.positive;
                  default = 1920;
                };
                height = lib.mkOption {
                  description = "Display height";
                  type = lib.types.ints.positive;
                  default = 1080;
                };
                refreshRate = lib.mkOption {
                  description = "Display refresh rate";
                  type = lib.types.ints.positive;
                  default = 60;
                };
              };
            };
            default = { };
          };
          de = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkEnableOption "de";
                name = lib.mkOption {
                  description = "Desktop Environment name";
                  type = lib.types.enum [
                    "sway"
                    "gnome"
                  ];
                  default = "sway";
                };
                wm = lib.mkOption {
                  description = "Wether the selected DE is a window manager";
                  type = lib.types.bool;
                  readOnly = true;
                  default = if cfg.gui.de.name != "gnome" then true else false;
                };
              };
            };
            default = { };
          };
        };
      };
      default = { };
    };

    program = lib.mkOption {
      description = "Program ref";
      type = lib.types.attrsOf (lib.types.str);
      readOnly = true;
      default = {
        terminal = "alacritty";
        editor = "nvim";
        multiplexer = "tmux";
        browser = "chromium";
        launcher = "wofi";
        notification = "dunst";
        video = "mpv";
        pdf = "zathura";
        image = "loupe";
      };
      default = { };
    };
  };
  config = {
    my = { };
  };
}
