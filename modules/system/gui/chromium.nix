{ lib, my, ... }:
let
  mkSiteSearchSettings =
    options:
    builtins.map (
      option:
      let
        name = builtins.elemAt option 0;
        url = builtins.elemAt option 2;
        viaGoogle = if lib.strings.hasPrefix "http" url then false else true;
      in
      {
        name = if viaGoogle then "Google ${name}" else name;
        shortcut = builtins.elemAt option 1;
        url = if viaGoogle then "https://www.google.com/search?q=site%3A${url}+{searchTerms}" else url;
      }
    ) options;

  mkBookmarks =
    bookmarks:
    builtins.map (bookmark: {
      name = builtins.elemAt bookmark 0;
      url = builtins.elemAt bookmark 1;
    }) bookmarks;

  mkExtensionSettings =
    extensions:
    builtins.listToAttrs (
      map (
        extension:
        let
          pin = if builtins.length extension > 1 then builtins.elemAt extension 1 else false;
        in
        {
          name = builtins.elemAt extension 0;
          value = {
            "installation_mode" = "force_installed";
            "toolbar_pin" = if pin then "force_pinned" else "default_unpinned";
            "update_url" = "https://clients2.google.com/service/update2/crx";
          };

        }
      ) extensions
    );

in
# NOTE:
# vist: chrome://flags/#enable-webrtc-allow-input-volume-adjustment
# and set it to disabled
{
  config = lib.mkIf my.gui.enable {
    programs.chromium = {
      enable = true;
      extraOpts = {
        PasswordManagerEnabled = false;
        RestoreOnStartup = 1;
        SiteSearchSettings = mkSiteSearchSettings [
          [
            "YouTube"
            "youtube"
            "https://www.youtube.com/results?search_query={searchTerms}"
          ]
          [
            "Nix Packages"
            "nix-pkg"
            "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}"
          ]
          [
            "Nix Options"
            "nix-option"
            "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}"
          ]
          [
            "Iconify"
            "icon"
            "https://icon-sets.iconify.design/?query={searchTerms}"
          ]
          [
            "Dribble"
            "dribble"
            "https://dribbble.com/search/shots/popular/web-design?q={searchTerms}"
          ]
          # Search sites via Google
          [
            "Reddit"
            "reddit"
            "reddit.com"
          ]
          [
            "MDN Web Docs"
            "mdn"
            "developer.mozilla.org"
          ]
          [
            "Github"
            "github"
            "github.com"
          ]
        ];
        ManagedBookmarks = mkBookmarks [
          [
            "WhatsApp"
            "web.whatsapp.com"
          ]
          [
            "Discord"
            "discord.com/channels/@me"
          ]
          [
            "Github"
            "github.com"
          ]
          [
            "Reddit"
            "www.reddit.com"
          ]
          [
            "Gmail"
            "mail.google.com/mail/u/0/#inbox"
          ]
          [
            "Gmail 1"
            "mail.google.com/mail/u/1/#inbox"
          ]
          [
            "Gmail 2"
            "mail.google.com/mail/u/2/#inbox"
          ]
          [
            "Crunchyroll"
            "crunchyroll.com"
          ]
          [
            "Indian Post Insurance"
            "pli.indiapost.gov.in"
          ]
          [
            "MyAnimeList"
            "myanimelist.net/animelist/SymphonySimper"
          ]
          [
            "Excalidraw"
            "excalidraw.com"
          ]
          [
            "ProtonDB"
            "www.protondb.com"
          ]
          [
            "Gemini"
            "gemini.google.com/app?hl=en-IN"
          ]
          [
            "Lichess"
            "https://lichess.org"
          ]

          # Dev
          [
            "Google Fonts"
            "fonts.google.com"
          ]
          [
            "Svelte"
            "svelte.dev"
          ]
          [
            "Svelte Changelog"
            "https://svelte-changelog.vercel.app/"
          ]
          [
            "Tailwindcss"
            "tailwindcss.com/docs/installation"
          ]
          [
            "Nix PR Tracker"
            "https://nixpk.gs/pr-tracker.html"
          ]
          [
            "Nixpkgs Manual"
            "https://ryantm.github.io/nixpkgs/functions/library/asserts/#sec-functions-library-asserts"
          ]
          [
            "Nix Manual"
            "https://teu5us.github.io/nix-lib.html#nix-builtin-functions"
          ]
          [
            "regex101"
            "https://regex101.com"
          ]
        ];
        ExtensionSettings = mkExtensionSettings [
          [
            "nngceckbapebfimnlniiiahkandclblb" # bitwarden
            true
          ]
          [
            "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
          ]
          [
            "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
          ]
          [
            "edibdbjcniadpccecjdfdjjppcpchdlm" # i don't care about cookies
          ]
          [
            "bnclejfcblondkjliiblkojdeloomadd" # mute tab
            true
          ]
        ];
      };
    };
  };
}
