{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.browser;
in
{
  options.my.programs.browser = {
    enable = lib.mkEnableOption "Browser";

    bookmarks = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.str
            (lib.types.submodule {
              options = {
                url = lib.mkOption {
                  type = lib.types.str;
                  description = "Site URL";
                };

                # `entry` and `browser` works only with home-manager
                entry = lib.mkEnableOption "Also show as desktop entry";
                browser = lib.mkOption {
                  type = lib.types.str;
                  description = "Browser to use for opening the desktop entry";
                  default = lib.getExe' pkgs.xdg-utils "xdg-open";
                };
              };
            })
          ]
        )
      );
      description = "Browser bookmarks";
      default = { };
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
            default = "@";
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

  config = lib.mkIf cfg.enable {
    my.programs.browser = {
      search = {
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
          Github = {
            url = "github.com";
            entry = true;
          };

          "Google Fonts" = "fonts.google.com";
          LeetCode = "leetcode.com";
          Regex101 = "regex101.com";
          "Svelte Changelog" = "svelte-changelog.vercel.app";
          "Svelte" = "svelte.dev";
          Tailwindcss = "tailwindcss.com/docs/installation";
        };

        Email = {
          Gmail = {
            url = "mail.google.com/mail/u/0/#inbox";
            entry = true;
          };

          "Gmail 1" = {
            url = "mail.google.com/mail/u/1/#inbox";
            entry = true;
          };
        };

        # Entertainment = {};

        Misc = {
          "Chrome Enterprise policy list" = "chromeenterprise.google/policies";
        };

        Music = {
          Spotify = "open.spotify.com";

          "YouTube Music" = {
            url = "music.youtube.com";
            entry = true;
          };
        };

        Nix = {
          "Nix Builtins" = "nix.dev/manual/nix/latest/language/builtins.html";
          "Nix PR Tracker" = "nixpk.gs/pr-tracker.html";
          "Nix Wiki" = "wiki.nixos.org/wiki/NixOS_Wiki";
          Noogle = "noogle.dev";
        };

        "Socila Media" = {
          Discord = {
            url = "discord.com/channels/@me";
            entry = true;
          };

          Reddit = "www.reddit.com";

          WhatsApp = {
            url = "web.whatsapp.com";
            entry = true;
          };

          YouTube = "youtube.com";
        };

        Utility = {
          Excalidarw = {
            url = "excalidraw.com";
            entry = true;
          };

          Keybr = {
            url = "www.keybr.com";
            entry = true;
          };

          Monkeytype = {
            url = "monkeytype.com";
            entry = true;
          };

          ProtonDB = "www.protondb.com";
        };
      };
    };
  };
}
