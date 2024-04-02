{ pkgs, ... }: {

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.gnome.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    # font = {
    #   name = "Sans";
    #   size = 11;
    # };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita-dark";
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
