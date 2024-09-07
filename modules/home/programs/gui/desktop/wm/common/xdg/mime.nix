{ config, pkgs, ... }:
let
  image = { "loupe" = "org.gnome.Loupe.desktop"; }.${config.my.program.image};
  pdf = { "zathura" = "org.pwmt.zathura.desktop"; }.${config.my.program.pdf};
in
{
  home.packages = [ pkgs.loupe ];

  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/png" = image;
        "image/jpeg" = image;
        "application/pdf" = pdf;
      };
    };
  };
}
