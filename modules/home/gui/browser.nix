{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.browser;

  mkGetURL = url: if lib.strings.hasPrefix "http" url then url else "https://${url}";
in
{
  options.my.programs.browser = {
    enable = lib.mkEnableOption "Browser";
    enableContainer = lib.mkEnableOption "Container";

    chromiumArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Defaut Command Line Args passed to chromium";
      readOnly = true;
      default = (
        let
          features = {
            disable = [ "WebRtcAllowInputVolumeAdjustment" ];
            enable = [
              # https://wiki.archlinux.org/title/Chromium#Hardware_video_acceleration
              "AcceleratedVideoDecodeLinuxGL"
              "AcceleratedVideoEncoder"
            ];
          };
        in
        (builtins.map (feature: "--${feature.name}-features=${builtins.concatStringsSep "," feature.value}")
          (
            builtins.filter (f: (builtins.length f.value) > 0) (
              lib.attrsets.mapAttrsToList (name: value: { inherit name value; }) features
            )
          )
        )
      );
    };

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

    extensions = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          (lib.types.submodule {
            options = {
              slug = lib.mkOption {
                type = lib.types.str;
                description = "Slug from extension page";
              };

              pin = lib.mkEnableOption "Pin to toolbar";
              private = lib.mkEnableOption "Run in private windows";
            };
          })
        ]
      );
      description = "Entensions to be force installed";
      default = { };
    };

    search = lib.mkOption {
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Name of the search provider";
          };

          alias = lib.mkOption {
            type = lib.types.str;
            description = "Alias for the search provider";
          };

          url = lib.mkOption {
            type = lib.types.str;
            description = "URL to pass query params";
            example = ''
              # until the user input
              `https://search.brave.com/search?q=`
            '';
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
    my = {
      desktop =
        let
          id = "firefox";
        in
        {
          autostart = [ id ];

          mime."${id}" = [
            "application/xhtml+xml"
            "text/html"
            "text/xml"
            "x-scheme-handler/ftp"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ];

          windows = [
            {
              inherit id;
              silent = true;
              workspace = 2;
            }
            {
              id = ".*sharing your screen.*";
              type = "title";
              silent = true;
              workspace = 10;
            }
          ];
        };

      programs.browser = {
        search = {
          name = "Brave";
          alias = "brave";
          url = "https://search.brave.com/search?q=";
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

        # for set key aka `id` refer: about:support#addons
        # or run `nix run github:tupakkatapa/mozid -- <addon-url>`
        extensions = lib.mkMerge [
          {
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              slug = "bitwarden-password-manager";
              pin = true;
            };

            "uBlock0@raymondhill.net" = {
              slug = "ublock-origin";
              private = true;
            };

            "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
              slug = "vimium-ff";
              private = true;
            };

            "chrome-mask@overengineer.dev" = {
              slug = "chrome-mask";
              private = true;
            };
          }

          (lib.mkIf cfg.enableContainer {
            "@testpilot-containers" = "multi-account-containers";
          })
        ];

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
            Discord = {
              url = "discord.com/channels/@me";
              entry = true;
            };

            Reddit = "www.reddit.com";

            WhatsApp = {
              url = "web.whatsapp.com";
              entry = true;
            };
          };

          Utility = {
            Excalidarw = {
              url = "excalidraw.com";
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

    # Browser
    programs.firefox = rec {
      enable = true;

      package = (
        pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
          drmSupport = true;
          pipewireSupport = true;
          waylandSupport = true;
          webrtcSupport = true;
        }) { }
      );

      policies = {
        DisableAccounts = true;
        DisableFirefoxAccounts = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisableProfileImport = true;
        DisableSetDesktopBackground = true;
        HttpsOnlyMode = "force_enabled";

        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;

        SearchSuggestEnabled = false;
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };

        HardwareAcceleration = true;
        PromptForDownloadLocation = true;
        TranslateEnabled = true;
        PictureInPicture = {
          Enabled = true;
          Locked = true;
        };

        DisplayBookmarksToolbar = "newtab";
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        NewTabPage = true;
        ShowHomeButton = false;
        FirefoxHome = {
          Search = false;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        Homepage.StartPage = "previous-session";

        ExtensionSettings = lib.mkMerge [
          {
            "*".installation_mode = "blocked"; # or `allowed`
          }

          (builtins.mapAttrs (
            name: value:
            let
              isSet = builtins.typeOf value == "set";
            in
            {
              # https://addons.mozilla.org/en-US/firefox/addon/<slug>
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${
                if isSet then value.slug else value
              }/latest.xpi";
              installation_mode = "force_installed";
              # now pinning is handled by settings
              # default_area = if lib.my.mkGetDefault extension "pin" false then "navbar" else "menupanel";
              default_area = "menupanel";
              private_browsing = if isSet then value.private else false;
            }
          ) (cfg.extensions))
        ];
      };

      profiles.default = {
        id = 0;
        isDefault = true;

        containersForce = true;
        containers.work = {
          id = 1;
          color = "blue";
          icon = "briefcase";
        };

        settings = {
          "app.shield.optoutstudies.enabled" = true;

          "browser.contentblocking.category" = "standard";

          "browser.ctrlTab.sortByRecentlyUsed" = true;

          "browser.uiCustomization.state" = {
            # not required keys `widget-overflow-fixed-list`, `unified-extensions-area`, `vertical-tabs`, `PersonalToolbar`,  `seen`, `dirtyAreaCache`, `newElementCount`
            placements = {
              nav-bar = builtins.concatLists [
                [
                  "back-button"
                  "forward-button"
                  "stop-reload-button"
                  "vertical-spacer" # not sure what it does, removing it doesn't seem to affect anything
                  "urlbar-container"
                ]
                (builtins.map
                  (
                    extension:
                    builtins.concatStringsSep "-" [
                      (lib.strings.stringAsChars (
                        c:
                        if
                          builtins.elem c [
                            "@"
                            "."
                            "{"
                            "}"
                          ]
                        then
                          "_"
                        else
                          c
                      ) extension)
                      "browser-action"
                    ]
                  )
                  (
                    builtins.attrNames (
                      lib.attrsets.filterAttrs (
                        _: value: (builtins.typeOf value == "set") && (value.pin == true)
                      ) cfg.extensions
                    )
                  )
                )
                [
                  "downloads-button"
                  "unified-extensions-button"
                  "reset-pbm-toolbar-button" # not sure what it does, removing it doesn't seem to affect anything
                  "fxa-toolbar-menu-button" # not sure what it does, removing it doesn't seem to affect anything
                ]
              ];
              toolbar-menubar = [ "menubar-items" ];
              TabsToolbar = [
                "tabbrowser-tabs"
                "new-tab-button"
                "alltabs-button"
              ];
            };
            currentVersion = 21; # Do not remove
          };

          "browser.urlbar.shortcuts.bookmarks" = false;
          "browser.urlbar.shortcuts.history" = false;
          "browser.urlbar.shortcuts.tabs" = false;
          "browser.urlbar.sponsoredTopSites" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.topsites" = false;
          "browser.urlbar.suggest.trending" = false;

          "sidebar.visibility" = "hide-sidebar";
          "sidebar.main.tools" = "history,bookmarks";

          "browser.toolbars.bookmarks.visibility" = policies.DisplayBookmarksToolbar;
        };

        search = {
          force = true;

          default = "default";
          privateDefault = "default";

          engines =
            let
              mkEngine =
                {
                  name,
                  alias,
                  url,
                }:
                {
                  inherit name;
                  definedAliases = [ "@${alias}" ];
                  # hide from url bar
                  metaData.hideOneOffButton = true;
                  urls = [ { template = url; } ];

                };
            in
            lib.mkMerge [
              {
                # hide from url bar
                google.metaData.hideOneOffButton = true;
                ddg.metaData.hideOneOffButton = true;

                # disable
                bing.metaData.hidden = true;
                wikipedia.metaData.hidden = true;

                default = mkEngine {
                  name = cfg.search.name;
                  alias = cfg.search.alias;
                  url = "${cfg.search.url}{searchTerms}";
                };
              }

              (builtins.mapAttrs (
                name: value:
                let
                  viaGoogle = if lib.strings.hasPrefix "http" value.url then false else true;
                in
                mkEngine {
                  name = if viaGoogle then "Google ${value.name}" else value.name;
                  alias = name;
                  url = if viaGoogle then "${cfg.search.url}site%3A${value.url}+{searchTerms}" else value.url;
                }
              ) cfg.engines)
            ];
        };

        bookmarks = {
          force = true;
          settings = [
            {
              toolbar = true;
              bookmarks = (
                builtins.map (book: {
                  name = book.name;
                  bookmarks = builtins.map (v: {
                    name = v.name;
                    url = mkGetURL (if builtins.typeOf v.value == "set" then v.value.url else v.value);
                  }) (lib.attrsets.attrsToList book.value);
                }) (lib.attrsets.attrsToList cfg.bookmarks)
              );
            }
          ];
        };
      };
    };

    # Entries
    xdg.desktopEntries =
      builtins.mapAttrs
        (
          name: value:
          let
            url = if lib.strings.hasPrefix "http" value.url then value.url else "https://${value.url}";
            scriptName = builtins.concatStringsSep "-" (lib.strings.splitString " " (lib.strings.toLower name));
            execScript = lib.getExe (
              pkgs.writeShellScriptBin scriptName # sh
                ''
                  ${value.browser} ${url}                
                ''
            );
          in
          {
            inherit name;
            type = "Application";
            genericName = name;
            comment = "Launch ${name}";
            categories = [ "X-MY-Bookmarks" ];
            terminal = false;
            exec = execScript;
            settings.StartupWMClass = name;
          }
        )
        (
          lib.attrsets.filterAttrs (_: value: (builtins.typeOf value == "set") && (value.entry == true)) (
            lib.attrsets.mergeAttrsList (builtins.attrValues cfg.bookmarks)
          )
        );
  };
}
