{
  my,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.browser;
in
{
  options.my.programs.browser = {
    enable = lib.mkEnableOption "Browser" // {
      default = my.gui.enable;
    };

    search = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Name of the search provider";
          };

          prefix = lib.mkOption {
            type = lib.types.str;
            description = "Prefix of alias";
          };

          alias = lib.mkOption {
            type = lib.types.str;
            description = "Alias for the search provider";
          };

          url = lib.mkOption {
            type = lib.types.str;
            description = "URL to pass query params";
            example = "https://search.brave.com/search?q=";
          };
        };
      };
      description = "Default search engine";
    };

    engines = lib.mkOption {
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
      extensions = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
        "lodbfhdipoipcjmlebjbgmmgekckhpfb" # harper
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      ];

      search = {
        prefix = "!";
        name = lib.mkDefault "Brave";
        alias = lib.mkDefault "brave";
        url = lib.mkDefault "https://search.brave.com/search?q=";
      };

      engines = {
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
        "mdn" = {
          name = "MDN Web Docs";
          url = "developer.mozilla.org";
        };
      };
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

          ShowHomeButton = false;
          HomepageIsNewTabPage = true;

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
