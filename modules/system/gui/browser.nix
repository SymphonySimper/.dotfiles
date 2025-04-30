{
  my,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.browser;

  blankPage = "file://${
    builtins.toFile "home.html" # html
      ''
        <!DOCTYPE html>
        <html>
          <head>
            <title>New Tab</title>
          </head>
          <body style="background-color: ${my.theme.color.base};"></body>
        </html>
      ''
  }";
in
{
  options.my.programs.browser = {
    extensions = lib.mkOption {
      type = lib.types.listOf (
        lib.types.oneOf [
          lib.types.str
          (lib.types.listOf lib.types.str)
        ]
      );
      description = "Entensions to be force installed";
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    my.programs.browser = {
      search.prefix = "!";
      extensions = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      ];
    };

    programs.chromium = {
      enable = true;

      extraOpts =
        let
          mkDefaultSearchProviderURL =
            {
              site ? null,
            }:
            "${cfg.search.url}${if site != null then "site%3A${site}+" else ""}{searchTerms}";
        in
        {
          # PasswordManagerEnabled = false;
          RestoreOnStartup = 1;
          DefaultBrowserSettingEnabled = false; # do not check for default browser
          GenAiDefaultSettings = 2; # disable all Genarative AI features
          AutofillCreditCardEnabled = false;
          AutofillAddressEnabled = false;
          AutoplayAllowed = false;
          BrowserLabsEnabled = false;

          # Balanced memory savings
          HighEfficiencyModeEnabled = true;
          MemorySaverModeSavings = 1;

          DefaultSearchProviderEnabled = true;
          DefaultSearchProviderName = cfg.search.name;
          DefaultSearchProviderSearchURL = mkDefaultSearchProviderURL { };
          DefaultSearchProviderNewTabURL = blankPage;

          ShowHomeButton = false;
          HomepageIsNewTabPage = true;
          HomepageLocation = blankPage;
          NewTabPageLocation = blankPage;

          SiteSearchSettings = builtins.map (
            option:
            let
              name = option.value.name;
              url = option.value.url;
              viaDefaultSearch = if lib.strings.hasPrefix "http" url then false else true;
            in
            {
              name = if viaDefaultSearch then "${cfg.search.name} ${name}" else name;
              shortcut = "${cfg.search.prefix}${option.name}";
              url = if viaDefaultSearch then mkDefaultSearchProviderURL { site = url; } else url;
            }
          ) (lib.attrsets.attrsToList cfg.engines);

          ManagedBookmarks = builtins.map (book: {
            name = book.name;
            children = builtins.map (
              v:
              let
                url = if builtins.typeOf v.value == "set" then v.value.url else v.value;
              in
              {
                name = v.name;
                url = if lib.strings.hasPrefix "http" url then url else "https://${url}";
              }
            ) (lib.attrsets.attrsToList book.value);
          }) (lib.attrsets.attrsToList cfg.bookmarks);

          ExtensionSettings = builtins.listToAttrs (
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
            ) cfg.extensions
          );
        };
    };
  };
}
