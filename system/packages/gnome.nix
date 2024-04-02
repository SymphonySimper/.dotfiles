{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # extensions
  environment.systemPackages = with pkgs.gnomeExtensions; [
    caffeine
    appindicator
  ];
}
