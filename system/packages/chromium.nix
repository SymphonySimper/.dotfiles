{ userSettings, ... }:
let
  mkSiteSearchSettings =
    options:
    builtins.map (option: {
      name = builtins.elemAt option 0;
      shortcut = builtins.elemAt option 1;
      url = builtins.elemAt option 2;
    }) options;

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
          "nix"
          "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}"
        ]
        [
          "Nix Options"
          "nix-options"
          "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}"
        ]
      ];
      ManagedBookmarks = mkBookmarks [
        [
          "WhatsApp"
          "web.whatsapp.com"
        ]
        [
          "Github"
          "github.com"
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
          "Discord"
          "discord.com/channels/@me"
        ]
        [
          "Indian Post Insurance"
          "pli.indiapost.gov.in"
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
}
