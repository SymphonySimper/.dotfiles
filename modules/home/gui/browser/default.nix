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
  programs = {
    chromium = {
      enable = true;
      package = pkgs.google-chrome;

      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--disable-features=WebRtcAllowInputVolumeAdjustment"
      ];
    };

    firefox = {
      enable = true;
      package = (
        pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
          drmSupport = true;
          pipewireSupport = true;
          waylandSupport = true;
          webrtcSupport = true;
        }) { }
      );

      policies = import ./policies.nix { inherit lib; };

      profiles.default = {
        id = 0;
        isDefault = true;

        containersForce = true;
        containers.work = {
          id = 1;
          color = "blue";
          icon = "briefcase";
        };

        settings = import ./settings.nix { inherit lib; };
        search = import ./search.nix { inherit pkgs lib; };

        bookmarks = {
          force = true;
          settings = builtins.mapAttrs (name: value: {
            inherit name;
            bookmarks = builtins.map mkGetSiteNameAndURL value;
          }) sites;
        };
      };
    };
  };

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
