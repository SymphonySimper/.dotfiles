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
            "uBlock0@raymondhill.net"
            "ublock-origin"
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

      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   bitwarden
      #   multi-account-containers
      #   ublock-origin
      #   vimium
      #   istilldontcareaboutcookies
      # ];
      #
      settings = {
        "extensions.autoDisableScopes" = 0;
      };
    };
  };
}
