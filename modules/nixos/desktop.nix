{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.desktop;
in
{
  options.desktop = {
    enable = lib.mkEnableOption "Desktop";
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;

    services.gnome = {
      # File search index
      localsearch.enable = false;
      tinysparql.enable = false;

      # Web accounts, calendar, contacts
      gnome-online-accounts.enable = false;
      evolution-data-server.enable = lib.mkForce false; # Upstream sets true

      # Network access to the computer
      rygel.enable = false;
      gnome-remote-desktop.enable = false;
      gnome-user-share.enable = false;

      gnome-browser-connector.enable = false; # Browser installs GNOME extensions
      gnome-initial-setup.enable = false; # First login setup
    };

    services.speechd.enable = false; # Text to speech for the orca screen reader
    services.avahi.enable = false; # mDNS service discovery
    services.colord.enable = false; # Display and printer colour profiles

    environment.gnome.excludePackages = with pkgs; [
      baobab # disk usage analyzer
      epiphany # browser
      geary # email
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-connections
      gnome-console
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-text-editor
      gnome-tour
      gnome-weather
      orca # screen reader
      seahorse # passwords and keys
      simple-scan
      snapshot # camera
      sushi # nautilus preview
      yelp
    ];
  };
}
