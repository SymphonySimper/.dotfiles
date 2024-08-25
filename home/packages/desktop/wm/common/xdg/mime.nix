{ userSettings, pkgs, ... }:
let
  image = { "loupe" = "org.gnome.Loupe.desktop"; }.${userSettings.programs.image};
  pdf = { "zathura" = "org.pwmt.zathura.desktop"; }.${userSettings.programs.pdf};
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
