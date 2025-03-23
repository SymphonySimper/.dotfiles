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
        shortcut = "@${builtins.elemAt option 1}";
        url = if viaGoogle then "https://www.google.com/search?q=site%3A${url}+{searchTerms}" else url;
      }
    ) options;

  mkBookmarks =
    bookmarks:
    builtins.map (bookmark: {
      name = builtins.elemAt bookmark 0;
      url = builtins.elemAt bookmark 1;
    }) bookmarks;

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

          # Search sites via Google
          [
            "Reddit"
            "rt"
            "reddit.com"
          ]
        ];

        ManagedBookmarks = mkBookmarks [
          [
            "Chrome Enterprise Policies"
            "chromeenterprise.google/policies"
          ]
        ];

        ExtensionSettings = mkExtensionSettings [
          "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
        ];
      };
    };
  };
}
