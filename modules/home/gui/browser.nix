{
  my,
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

    args = lib.mkOption {
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

    entries = lib.mkOption {
      description = "URLs as desktop entries";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            url = lib.mkOption {
              description = "URL to open";
              type = lib.types.str;
            };

            browser = lib.mkOption {
              description = "Browser to open with";
              type = lib.types.str;
              default = lib.getExe' pkgs.xdg-utils "xdg-open";
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    my = {
      desktop = {
        autostart = [ "chromium-browser" ];

        mime."chromium-browser" = [
          "application/xhtml+xml"
          "text/html"
          "text/xml"
          "x-scheme-handler/ftp"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];

        windows = [
          {
            id = "chromium-browser";
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

      programs.browser.entries = {
        # Social Media
        WhatsApp.url = "web.whatsapp.com";
        Discord.url = "discord.com/channels/@me";

        # Email
        Gmail.url = "mail.google.com/mail/u/0/#inbox";
        "Gmail 1".url = "mail.google.com/mail/u/1/#inbox";

        # Utility
        Excalidraw.url = "excalidraw.com";
        Monkeytype.url = "monkeytype.com";
      };
    };

    # Browser
    programs.chromium = {
      enable = true;
      package = pkgs.chromium.override { enableWideVine = true; };
      commandLineArgs = cfg.args;

      extensions =
        let
          theme = {
            frappe = "olhelnoplefjdmncknfphenjclimckaf";
            latte = "jhjnalhegpceacdhbplhnakmkdliaddd";
            macchiato = "cmpdlhmnmjhihmcfnigoememnffkimlk";
            mocha = "bkkmolkhemgaeaeggcmfbghljjjoofoh";
          };
        in
        [
          theme.${my.theme.flavor} # Catppuccin theme
          "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
          "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        ];
    };

    # Entries
    xdg.desktopEntries = builtins.mapAttrs (
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
    ) cfg.entries;
  };
}
