{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.browser;
  category = "X-MY-Bookmarks";
in
{
  options.my.programs.browser = {
    enable = lib.mkEnableOption "Browser";

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
  }
  // lib.my.mkCommandOption {
    category = "Browser";
    command = "chromium-browser";
    args = {
      chromium = (
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
  };

  config = lib.mkIf cfg.enable {
    my.programs = {
      desktop = {
        autostart = [ cfg.command ];
        appfolder.Bookmarks.categories = [ category ];
      };

      browser.bookmarks = {
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
        Gmail = "mail.google.com/mail/u/0/#inbox";
        "Gmail 1" = "mail.google.com/mail/u/1/#inbox";

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
    };

    # Browser
    catppuccin.chromium.enable = false;

    programs.chromium = {
      enable = true;
      package = pkgs.chromium.override { enableWideVine = true; };
      commandLineArgs = cfg.args.chromium;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      ];
    };

    # Entries
    xdg.desktopEntries = builtins.mapAttrs (
      name: value:
      let
        isString = builtins.typeOf value == "string";
        url = if isString then value else value.url;
        scriptName = builtins.concatStringsSep "-" (lib.strings.splitString " " (lib.strings.toLower name));

        execScript = lib.getExe (
          pkgs.writeShellScriptBin scriptName # sh
            ''
              exec ${if isString then cfg.command else value.browser} ${
                if lib.strings.hasPrefix "http" url then url else "https://${url}"
              }                
            ''
        );
      in
      {
        inherit name;
        type = "Application";
        genericName = name;
        comment = "Launch ${name}";
        categories = [ category ];
        terminal = false;
        exec = execScript;
        settings.StartupWMClass = name;
      }
    ) cfg.bookmarks;
  };
}
