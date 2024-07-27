{ ... }: {
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
