{ lib, my, ... }:
let
  mkSiteSearchSettings =
    options:
    builtins.map (
      option:
      let
        name = builtins.elemAt option 0;
        url = builtins.elemAt option 2;
        viaGoogle = if lib.strings.hasPrefix "http" url then false else true;
      in
      {
        name = if viaGoogle then "Google ${name}" else name;
        shortcut = "!${builtins.elemAt option 1}";
        url = if viaGoogle then "https://www.google.com/search?q=site%3A${url}+{searchTerms}" else url;
      }
    ) options;

  mkBookmarks =
    bookmarks:
    builtins.map (book: {
      name = book.name;
      children = builtins.map (v: {
        name = builtins.elemAt v 0;
        url = builtins.elemAt v 1;
      }) book.value;
    }) (lib.attrsets.attrsToList bookmarks);

  mkExtensionSettings =
    extensions:
    builtins.listToAttrs (
      map (
        extension:
        let
          isList = builtins.typeOf extension == "list";
        in
        {
          name = if isList then builtins.elemAt extension 0 else extension;
          value = {
            "installation_mode" = "force_installed";
            "toolbar_pin" = if isList then "force_pinned" else "default_unpinned";
            "update_url" = "https://clients2.google.com/service/update2/crx";
          };
        }
      ) extensions
    );
in
{
  config = lib.mkIf my.gui.enable {
    programs.chromium = {
      enable = true;

      extraOpts = {
        # PasswordManagerEnabled = false;
        RestoreOnStartup = 1;
        DefaultBrowserSettingEnabled = false; # do not check for default browser
        GenAiDefaultSettings = 2; # disable all Genarative AI features
        AutofillCreditCardEnabled = false;
        AutofillAddressEnabled = false;
        AutoplayAllowed = false;
        BrowserLabsEnabled = false;

        SiteSearchSettings = mkSiteSearchSettings [
          [
            "YouTube"
            "yt"
            "https://www.youtube.com/results?search_query={searchTerms}"
          ]
          [
            "Nix Packages"
            "np"
            "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}"
          ]
          [
            "Nix Options"
            "no"
            "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}"
          ]
          [
            "Nix Noogle"
            "ng"
            "https://noogle.dev/q?term={searchTerms}"
          ]

          # Search sites via Google
          [
            "Reddit"
            "rt"
            "reddit.com"
          ]
        ];

        ManagedBookmarks = mkBookmarks {
          Nix = [
            [
              "Noogle"
              "noogle.dev"
            ]
            [
              "Nix Builtins"
              "nix.dev/manual/nix/latest/language/builtins.html"
            ]
            [
              "Nix PR Tracker"
              "nixpk.gs/pr-tracker.html"
            ]
            [
              "Nix Wiki"
              "https://wiki.nixos.org/wiki/NixOS_Wiki"
            ]
          ];

          Misc = [
            [
              "Chrome Enterprise policy list"
              "chromeenterprise.google/policies"
            ]
          ];
        };

        ExtensionSettings = mkExtensionSettings [
          "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
        ];
      };
    };
  };
}
