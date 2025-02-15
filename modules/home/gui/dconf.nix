{ lib, my, ... }:
{
  config = lib.mkIf my.gui.desktop.enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = if my.theme.dark then "prefer-dark" else "default";
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
      };
    };
  };
}
