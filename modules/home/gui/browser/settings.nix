{ lib, ... }:
{
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
              ) extension.id)
              "browser-action"
            ]
          )
          (builtins.filter (extension: lib.my.mkGetDefault extension "pin" false) (import ./extensions.nix))
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

  "browser.ml.chat.provider" = "https://gemini.google.com";

  "sidebar.visibility" = "hide-sidebar";
  "sidebar.main.tools" = "history,bookmarks";

  "browser.toolbars.bookmarks.visibility" = "never";
}
