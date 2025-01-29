{ lib, my, ... }:
{
  config = lib.mkIf my.gui.desktop.enable {
    dconf = {
      enable = true;
      settings = lib.mkMerge [
        {
          "org/gnome/desktop/interface" = {
            color-scheme = if my.theme.dark then "prefer-dark" else "prefer-light";
            cursor-size = 16;
            cursor-theme = "Adwaita";
            enable-animations = true;
            gtk-theme = my.theme.gtk;
            icon-theme = "Adwaita";
            show-battery-percentage = true;
            toolkit-accessibility = false;
          };

          "org/gnome/nautilus/preferences" = {
            click-policy = "single";
            default-folder-viewer = "list-view";
            migrated-gtk-settings = true;
            search-filter-time-type = "last_modified";
            search-view = "list-view";
          };
        }
        (lib.mkIf (!my.gui.desktop.wm) {
          "org/gnome/shell" = {
            favorite-apps = [
              "Alacritty.desktop"
              "google-chrome.desktop"
            ];
          };

          "org/gnome/desktop/background" = {
            picture-uri = my.theme.wallpaper;
            picture-uri-dark = my.theme.wallpaper;
          };

          "org/gnome/desktop/screensaver" = {
            picture-uri = my.theme.wallpaper;
          };

          "org/gnome/mutter" = {
            experimental-features = [ "scale-monitor-framebuffer" ];
          };

          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = false;
          };

          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            natural-scroll = false;
            tap-to-click = true;
            two-finger-scrolling-enabled = true;
          };

          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
            ];
            home = [ "<Super>e" ];
            mic-mute = [ "F8" ];
            play = [ "F7" ];
            www = [ "<Super>f" ];
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>Return";
            command = "alacritty";
            name = "Alacritty";
          };
        })
      ];
    };
  };
}
