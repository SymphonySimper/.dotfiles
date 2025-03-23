{pkgs, lib, ... }:
let
  defaultApplications = {
    "org.gnome.Loupe" = [
      "image/jpeg"
      "image/png"
    ];

    "org.pwmt.zathura" = [
      "application/pdf"
    ];

    "google-chrome" = [
      "application/xhtml+xml"
      "text/html"
      "text/xml"
      "x-scheme-handler/ftp"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];

  };
in
{
  home.packages = [ pkgs.loupe ];

  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = builtins.listToAttrs (
        lib.lists.flatten (
          lib.attrsets.mapAttrsToList (
            name: value:
            (builtins.map (v: {
              name = v;
              value = "${name}.desktop";
            }) value)
          ) defaultApplications
        )
      );
    };
  };
}
