{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.chromium;
  category = "X-MY-Bookmarks";
in
{
  options.programs.chromium = {
    bookmarks = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str

          (lib.types.submodule {
            options = {
              url = lib.mkOption {
                type = lib.types.str;
                description = "Site URL";
              };

              browser = lib.mkOption {
                type = lib.types.str;
                description = "Browser to use for opening the desktop entry";
              };
            };
          })
        ]
      );
      description = "Browser bookmarks";
      default = { };
    };
  };

  config = {
    desktop.gnome.app-folders.Bookmarks = [ category ];

    programs.chromium.bookmarks = {
      # Bank
      EPFO = "unifiedportal-mem.epfindia.gov.in/memberinterface";
      "EPFO Pasbook" = "passbook.epfindia.gov.in/MemberPassBook/login";

      # Bills
      "Airfiber Networks" = "login.airfiber.co.in/customer_portal";
      "Indian Post Insurance" = "pli.indiapost.gov.in";

      # Dev
      "CSSBattle" = "cssbattle.dev";
      "dotfiles" = "https://github.com/SymphonySimper/.dotfiles";
      Github = "github.com";
      "Google Fonts" = "fonts.google.com";
      JoshWComeauCources = "courses.joshwcomeau.com";
      LeetCode = "leetcode.com";
      "NPM Clayien Packages" = "www.npmjs.com/settings/clayien/packages";
      Regex101 = "regex101.com";
      "Svelte Changelog" = "svelte-changelog.vercel.app";
      "Svelte" = "svelte.dev";
      Tailwindcss = "tailwindcss.com/docs/installation";

      # Email
      Gmail = "mail.google.com/mail/u/0";
      "Gmail 1" = "mail.google.com/mail/u/1";
      "Gmail 2" = "mail.google.com/mail/u/2";

      # Misc
      "Chrome Enterprise policy list" = "chromeenterprise.google/policies";

      # Nix
      "Nix Builtins" = "nix.dev/manual/nix/latest/language/builtins.html";
      "Nix PR Tracker" = "nixpkgs-tracker.ocfox.me";
      "Nix Wiki" = "wiki.nixos.org/wiki/NixOS_Wiki";
      Noogle = "noogle.dev";

      # Socila Media
      Discord = "discord.com/channels/@me";
      Reddit = "www.reddit.com";
      WhatsApp = "web.whatsapp.com";
      YouTube = "youtube.com";

      # Utility
      Excalidarw = "excalidraw.com";
      Keybr = "www.keybr.com";
      Monkeytype = "monkeytype.com";
      Squoosh = "squoosh.app";
      Virustotal = "www.virustotal.com";
    };

    # Entries
    xdg.desktopEntries = builtins.mapAttrs (
      name: value:
      let
        isURL = builtins.typeOf value == "string";
        browser = if isURL then "chromium-browser" else value.browser;
        _url = if isURL then value else value.url;
        url = if lib.strings.hasPrefix "http" _url then _url else "https://${_url}";
      in
      {
        inherit name;
        type = "Application";
        genericName = name;
        comment = "Launch ${name}";
        categories = [ category ];
        terminal = false;
        exec = "${browser} ${url}";
        settings.StartupWMClass = name;

        actions = {
          "new-window" = {
            name = "New Window";
            exec = "${browser} --new-window ${url}";
          };
        };
      }
    ) cfg.bookmarks;
  };
}
