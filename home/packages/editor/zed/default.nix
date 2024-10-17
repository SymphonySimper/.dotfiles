{
  lib,
  userSettings,
  ...
}:
{
  config = lib.mkIf (true) {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "catppuccin"
        "svelte"
      ];
      userSettings = {
        features = {
          copilot = false;
        };
        telemetry = {
          metrics = false;
        };

        # keybinds
        vim_mode = true;

        # theme
        theme = rec {
          mode = if userSettings.theme.dark then "dark" else "light";
          light = "Catppuccin ${
            builtins.concatStringsSep "" [
              (lib.strings.toUpper (builtins.substring 0 1 userSettings.theme.flavor))
              (builtins.substring 1 (builtins.length (
                lib.strings.stringToCharacters userSettings.theme.flavor
              )) userSettings.theme.flavor)
            ]
          }";
          dark = light;
        };

        # Font
        ui_font_size = 16;
        buffer_font_size = 16;
        buffer_font_family = userSettings.font.mono;
        ui_font_family = userSettings.font.sans;
      };
    };
  };
}
