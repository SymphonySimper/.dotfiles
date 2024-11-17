{ my, pkgs, ... }:
let
  image = { "loupe" = "org.gnome.Loupe.desktop"; }.${my.programs.image};
  pdf = { "zathura" = "org.pwmt.zathura.desktop"; }.${my.programs.pdf};
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
