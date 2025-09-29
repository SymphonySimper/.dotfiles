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
          lib.types.submodule {
            options = {
              url = lib.mkOption {
                type = lib.types.str;
                description = "Site URL";
              };
              # `entry` and `browser` works only with home-manager
              entry = (lib.mkEnableOption "Also show as desktop entry") // {
                default = true;
              };
              browser = lib.mkOption {
                type = lib.types.str;
                description = "Browser to use for opening the desktop entry";
                default = lib.getExe' pkgs.xdg-utils "xdg-open";
              };
            };
          }
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
        Bank = {
          EPFO.url = "unifiedportal-mem.epfindia.gov.in/memberinterface";
          "EPFO Pasbook".url = "passbook.epfindia.gov.in/MemberPassBook/login";
        };

        Bills = {
          "Airfiber Networks".url = "login.airfiber.co.in/customer_portal";
          "Indian Post Insurance".url = "pli.indiapost.gov.in";
        };

        Dev = {
          "CSSBattle".url = "cssbattle.dev";
          Github.url = "github.com";
          "Google Fonts".url = "fonts.google.com";
          LeetCode.url = "leetcode.com";
          "NPM Clayien Packages".url = "www.npmjs.com/settings/clayien/packages";
          Regex101.url = "regex101.com";
          "Svelte Changelog".url = "svelte-changelog.vercel.app";
          "Svelte".url = "svelte.dev";
          Tailwindcss.url = "tailwindcss.com/docs/installation";
          JoshWComeauCources.url = "courses.joshwcomeau.com";
        };

        Email = {
          Gmail.url = "mail.google.com/mail/u/0/#inbox";
          "Gmail 1".url = "mail.google.com/mail/u/1/#inbox";
        };

        # Entertainment = {};

        Misc = {
          "Chrome Enterprise policy list".url = "chromeenterprise.google/policies";
        };

        Nix = {
          "Nix Builtins".url = "nix.dev/manual/nix/latest/language/builtins.html";
          "Nix PR Tracker".url = "nixpk.gs/pr-tracker.html";
          "Nix Wiki".url = "wiki.nixos.org/wiki/NixOS_Wiki";
          Noogle.url = "noogle.dev";
        };

        "Socila Media" = {
          Discord.url = "discord.com/channels/@me";
          Reddit.url = "www.reddit.com";
          WhatsApp.url = "web.whatsapp.com";
          YouTube.url = "youtube.com";
        };

        Utility = {
          Excalidarw.url = "excalidraw.com";
          Keybr.url = "www.keybr.com";
          Monkeytype.url = "monkeytype.com";
          Squoosh.url = "squoosh.app";
          Virustotal.url = "www.virustotal.com";
        };
      };
    };
  };
}
