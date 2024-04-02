{ ... }: {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "Alacritty.desktop"
          "firefox.desktop"
          "spotify.desktop"
        ];
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-animations = true;
        show-battery-percentage = true;
        toolkit-accessibility = false;
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

      "org/gnome/nautilus/preferences" = {
        click-policy = "single";
        default-folder-viewer = "list-view";
        migrated-gtk-settings = true;
        search-filter-time-type = "last_modified";
        search-view = "list-view";
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
    };
  };
}
