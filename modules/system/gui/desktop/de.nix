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

    environment.gnome.excludePackages =
      with pkgs.gnome;
      [
        gnome-characters
        gnome-contacts
        gnome-maps
        gnome-music
        gnome-shell-extensions
        gnome-weather
      ]
      ++ (with pkgs; [
        epiphany
        geary
        gnome-connections
        gnome-text-editor
        gnome-tour
        simple-scan
        yelp
      ]);

    environment.systemPackages = with pkgs; [
      foliate
      gnome-tweaks

      # extensions
      gnomeExtensions.caffeine
      gnomeExtensions.appindicator
    ];
  };
}
