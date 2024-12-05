{
  pkgs,
  lib,
  my,
  ...
}:
{
  config = lib.mkIf (my.gui.desktop.enable && !my.gui.desktop.wm) {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      excludePackages = [ pkgs.xterm ];
    };

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      geary
      gnome-characters
      gnome-connections
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-shell-extensions
      gnome-text-editor
      gnome-tour
      gnome-weather
      simple-scan
      yelp
    ];

    environment.systemPackages = with pkgs; [
      foliate
      gnome-tweaks

      # extensions
      gnomeExtensions.caffeine
      gnomeExtensions.appindicator
    ];
  };
}
