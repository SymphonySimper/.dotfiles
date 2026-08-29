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

          url = lib.mkOption {
            type = lib.types.str;
            description = "URL to pass query params";
            example = "https://search.brave.com/search?q=";
          };
        };
      };
      description = "Default search engine";
    };
  };

  config = {
    programs.chromium = {
      search = {
        name = lib.mkDefault "P1ain";
        url = lib.mkDefault "https://p1a.in/";
      };

      extraOpts = {
        DefaultSearchProviderEnabled = true;
        DefaultSearchProviderName = cfg.search.name;
        DefaultSearchProviderSearchURL = "${cfg.search.url}{searchTerms}";
      };
    };
  };
}
