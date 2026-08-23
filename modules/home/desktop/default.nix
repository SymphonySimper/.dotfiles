{
  config,
  lib,
  ...
}:
let
  cfg = config.desktop;
in
{
  imports = [
    ./app-folders.nix
    ./extensions.nix
    ./keybinds.nix
    ./wallpaper.nix
  ];

  options.desktop = {
    enable = lib.mkEnableOption "Desktop";
  };

  config = lib.mkIf cfg.enable {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/mutter" = {
          dynamic-workspaces = true;

          experimental-features = [
            # "scale-monitor-framebuffer" # fractional scaling
            # "variable-refresh-rate"
          ];
        };

        # shell
        "org/gnome/shell" = {
          app-picker-layout = [ ]; # resets app order
          favorite-apps = [ ];
        };

        "org/gnome/shell/app-switcher".current-workspace-only = true;

        "org/gnome/desktop/interface" = {
          enable-animations = true;
          enable-hot-corners = false;
          show-battery-percentage = true;
        };

        "org/gnome/desktop/sound" = {
          allow-volume-above-100-percent = true;
        };

        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = false;
          night-light-schedule-automatic = false;
          night-light-temperature = lib.hm.gvariant.mkUint32 3700;
        };

        ## mouse
        "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
        "org/gnome/desktop/peripherals/touchpad" = {
          natural-scroll = false;
          two-finger-scrolling-enabled = true;
        };

        # applications
        "org/gnome/nautilus/preferences" = {
          click-policy = "single";
          default-folder-viewer = "list-view";
          migrated-gtk-settings = true;
          search-filter-time-type = "last_modified";
          search-view = "list-view";
        };

        # privacy
        "org/gnome/desktop/privacy" = {
          remove-old-temp-files = true;
          remove-old-trash-files = true;
        };
      };
    };
  };
}
