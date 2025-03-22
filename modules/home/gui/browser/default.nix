{ pkgs, lib, ... }:
let
  sites = import ./bookmarks.nix;

  mkGetSiteNameAndURL =
    site:
    let
      _url = builtins.elemAt site 1;
    in
    {
      name = builtins.elemAt site 0;
      url = if lib.strings.hasPrefix "http" _url then _url else "https://${_url}";
    };
in
{
  imports = [
    ./chromium.nix

    (import ./firefox {
      inherit
        pkgs
        lib
        sites
        mkGetSiteNameAndURL
        ;
    })
  ];

  xdg.desktopEntries = builtins.listToAttrs (
    builtins.map
      (
        entry:
        let
          site = mkGetSiteNameAndURL entry;
        in
        {
          name = site.name;
          type = "entry";
          value = {
            name = site.name;
            type = "Application";
            genericName = site.name;
            comment = "Launch ${site.name}";
            categories = [ "Application" ];
            terminal = false;
            exec = "${lib.getExe' pkgs.xdg-utils "xdg-open"} \"${site.url}\" %U";
            settings = {
              StartupWMClass = site.name;
            };
          };
        }
      )
      (
        builtins.filter (site: (builtins.length site == 3) && (builtins.elemAt site 2)) (
          builtins.concatLists (builtins.attrValues sites)
        )
      )
  );
}
