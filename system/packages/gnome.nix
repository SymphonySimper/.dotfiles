{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = [ pkgs.xterm ];
  };

  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany
    geary
    gnome-characters
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-shell-extensions
    gnome-weather
    simple-scan
    yelp
  ] ++ (with pkgs; [
    gnome-connections
    gnome-text-editor
    gnome-tour
  ]);

  environment.systemPackages = with pkgs; [
    gnome3.gnome-tweaks

    # extensions
    gnomeExtensions.caffeine
    gnomeExtensions.appindicator
  ];
}
