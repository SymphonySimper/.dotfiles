{ pkgs, ... }: {

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (google-fonts.override { fonts = [ "Poppins" ]; })
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };

  gtk = {
    enable = true;
    catppuccin.enable = false;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    # font = {
    #   name = "Sans";
    #   size = 11;
    # };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      catppuccin.enable = false;
      name = "adwaita-dark";
    };
  };
}
