{ lib, ... }:
let
  engines = [
    {
      name = "YouTube";
      alias = "yt";
      url = "https://www.youtube.com/results?search_query={searchTerms}";
    }
    {
      name = "Nix Packages";
      alias = "np";
      url = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
    }
    {
      name = "Nix Options";
      alias = "no";
      url = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
    }
    {
      name = "Iconify";
      alias = "icon";
      url = "https://icon-sets.iconify.design/?query={searchTerms}";
    }
    {
      name = "Dribble";
      alias = "dribble";
      url = "https://dribbble.com/search/shots/popular/web-design?q={searchTerms}";
    }

    # Search sites via Google
    {
      name = "Reddit";
      alias = "rt";
      url = "reddit.com";
    }
    {
      name = "MDN Web Docs";
      alias = "mdn";
      url = "developer.mozilla.org";
    }
    {
      name = "Github";
      alias = "gh";
      url = "github.com";
    }
  ];

in
{
  force = true;

  default = "google";
  privateDefault = "google";

  engines =
    {
      # hide from url bar
      google.metaData.hideOneOffButton = true;
      ddg.metaData.hideOneOffButton = true;

      # disable
      bing.metaData.hidden = true;
      wikipedia.metaData.hidden = true;
    }
    // (builtins.listToAttrs (
      builtins.map (
        engine:
        let
          viaGoogle = if lib.strings.hasPrefix "http" engine.url then false else true;
        in
        {
          name = builtins.concatStringsSep "-" (
            lib.strings.splitString " " (lib.strings.toLower engine.name)
          );
          value = {
            name = if viaGoogle then "Google ${engine.name}" else engine.name;
            urls = [
              {
                template =
                  if viaGoogle then
                    "https://www.google.com/search?q=site%3A${engine.url}+{searchTerms}"
                  else
                    engine.url;
              }
            ];
            definedAliases = [ "@${engine.alias}" ];
            # hide from url bar
            metaData.hideOneOffButton = true;
          };
        }
      ) engines
    ));
}
