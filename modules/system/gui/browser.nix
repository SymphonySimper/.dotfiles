{
  my,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.browser;

  DefaultSearchProvider = "Brave";
  mkDefaultSearchProviderURL =
    {
      site ? null,
    }:
    "https://search.brave.com/search?q=${if site != null then "site%3A${site}+" else ""}{searchTerms}";

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
    enable = lib.mkEnableOption "Browser Policy";

    bookmarks = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      description = "Browser bookmarks";
      default = { };
    };

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

    search = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name to be show in address bar";
            };

            url = lib.mkOption {
              type = lib.types.str;
              description = "URL of search provider";
            };
          };
        }
      );
      description = "Site search providers";
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    my.programs.browser = {
      search = {
        "ng" = {
          name = "Nix Noogle";
          url = "https://noogle.dev/q?term={searchTerms}";
        };
        "no" = {
          name = "Nix Options";
          url = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
        };
        "np" = {
          name = "Nix Packages";
          url = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
        };

        "yt" = {
          name = "YouTube";
          url = "https://www.youtube.com/results?search_query={searchTerms}";
        };

        # Search sites via Default Search Provider
        "rt" = {
          name = "Reddit";
          url = "reddit.com";
        };
      };

      # extensions = [
      #   "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      # ];

      bookmarks = {
        Anime = {
          Crunchyroll = "crunchyroll.com";
          MyAnimeList = "myanimelist.net/animelist/SymphonySimper";
        };

        Bills = {
          "Airfiber Networks" = "https://login.airfiber.co.in/customer_portal";
          "Indian Post Insurance" = "pli.indiapost.gov.in";
        };

        Dev = {
          Github = "github.com";
          "Google Fonts" = "fonts.google.com";
          LeetCode = "leetcode.com";
          Regex101 = "regex101.com";
          "Svelte Changelog" = "svelte-changelog.vercel.app";
          "Svelte" = "svelte.dev";
          Tailwindcss = "tailwindcss.com/docs/installation";
        };

        Email = {
          Gmail = "mail.google.com/mail/u/0/#inbox";
          "Gmail 1" = "mail.google.com/mail/u/1/#inbox";
        };

        Entertainment = {
          YouTube = "youtube.com";
          "YouTube Music" = "music.youtube.com";
        };

        Misc = {
          "Chrome Enterprise policy list" = "chromeenterprise.google/policies";
        };

        Nix = {
          "Nix Builtins" = "nix.dev/manual/nix/latest/language/builtins.html";
          "Nix PR Tracker" = "nixpk.gs/pr-tracker.html";
          "Nix Wiki" = "wiki.nixos.org/wiki/NixOS_Wiki";
          Noogle = "noogle.dev";
        };

        "Socila Media" = {
          Discord = "discord.com/channels/@me";
          Reddit = "www.reddit.com";
          WhatsApp = "web.whatsapp.com";
        };

        Utility = {
          Excalidarw = "excalidraw.com";
          Monkeytype = "monkeytype.com";
          ProtonDB = "www.protondb.com";
        };
      };
    };

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

        # Balanced memory savings
        HighEfficiencyModeEnabled = true;
        MemorySaverModeSavings = 1;

        DefaultSearchProviderEnabled = true;
        DefaultSearchProviderName = DefaultSearchProvider;
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
            name = if viaDefaultSearch then "${DefaultSearchProvider} ${name}" else name;
            shortcut = "!${option.name}";
            url = if viaDefaultSearch then mkDefaultSearchProviderURL { site = url; } else url;
          }
        ) (lib.attrsets.attrsToList cfg.search);

        ManagedBookmarks = builtins.map (book: {
          name = book.name;
          children = builtins.map (v: {
            name = v.name;
            url = if lib.strings.hasPrefix "http" v.value then v.value else "https://${v.value}";
          }) (lib.attrsets.attrsToList book.value);
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
