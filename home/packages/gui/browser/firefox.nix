{ pkgs, ... }:
let
  mkExtensions =
    extensions:
    (builtins.listToAttrs (
      map (
        extension:
        let
          name = builtins.elemAt extension 0;
          id = builtins.elemAt extension 1;
          pin = if builtins.length extension == 3 then builtins.elemAt extension 2 else false;
        in
        {
          inherit name;
          value = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
            installation_mode = "force_installed";
            default_area = if pin then "navbar" else "menupanel";
          };
        }
      ) extensions
    ));
in
{
  programs.firefox = {
    enable = true;

    policies = {
      DisableFirefoxAccounts = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      NoDefaultBookmarks = true;
      OverrideFirstRunPage = "";
      Homepage = {
        StartPage = "previous-session";
      };
      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = false;
      };

      HardwareAcceleration = true;

      # UI
      DisplayBookmarksToolbar = "never";

      ExtensionSettings =
        {
          "*" = {
            installation_mode = "blocked";
            blocked_install_message = "Not allowed";
          };
        }
        // (mkExtensions [
          [
            "{446900e4-71c2-419f-a6a7-df9c091e268b}"
            "bitwarden-password-manager"
            true
          ]
          [
            "uBlock0@raymondhill.net"
            "ublock-origin"
          ]
          [
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}"
            "vimium-ff"
            true
          ]
          [
            "idcac-pub@guus.ninja"
            "istilldontcareaboutcookies"
          ]
        ]);
    };

    profiles.default = {
      name = "default";
      isDefault = true;
      search = {
        default = "Google";
        force = true;
      };

      containersForce = true;
      containers = {
        work = {
          color = "blue";
          icon = "briefcase";
          id = 1;
        };
      };
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "my-firefox-extension" ''
      ${pkgs.curl}/bin/curl -L -G --data-urlencode "page_size=2" \
      --data-urlencode "q=$1" -H "Accept: application/json" 'https://addons.mozilla.org/api/v5/addons/search' \
      | ${pkgs.jq}/bin/jq "[ .results[] | { guid: .guid, slug: .slug } ]"
    '')
  ];
}
