{ config, lib, ... }:
let
  cfg = config.programs.chromium;
in
{
  options.programs.chromium = {
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
  };

  config = {
    programs.chromium = {
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

      extraOpts =
        let
          mkDefaultSearchProviderURL =
            {
              site ? null,
            }:
            "${cfg.search.url}${if site != null then "site%3A${site}+" else ""}{searchTerms}";
        in
        {
          DefaultSearchProviderEnabled = true;
          DefaultSearchProviderName = cfg.search.name;
          DefaultSearchProviderSearchURL = mkDefaultSearchProviderURL { };

          SiteSearchSettings = map (
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
        };
    };
  };
}
