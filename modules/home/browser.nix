{
  my,
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
  };

  config = lib.mkIf cfg.enable {
    my.programs = {
      desktop =
        let
          id = "chromium-browser";
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

          automove = [
            {
              name = "${id}.desktop";
              workspace = 2;
            }
          ];

          appfolder.Bookmarks.categories = [ category ];
        };
    };

    # Browser
    programs.chromium = {
      enable = true;
      package = pkgs.chromium.override { enableWideVine = true; };
      commandLineArgs = cfg.chromiumArgs;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        (
          # Catppuccin theme
          {
            frappe = "olhelnoplefjdmncknfphenjclimckaf";
            latte = "jhjnalhegpceacdhbplhnakmkdliaddd";
            macchiato = "cmpdlhmnmjhihmcfnigoememnffkimlk";
            mocha = "bkkmolkhemgaeaeggcmfbghljjjoofoh";
          }
          .${my.theme.flavor}
        )
      ];
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
                  exec ${value.browser} ${url}                
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
        )
        (
          lib.attrsets.filterAttrs (_: value: (builtins.typeOf value == "set") && (value.entry == true)) (
            lib.attrsets.mergeAttrsList (builtins.attrValues cfg.bookmarks)
          )
        );
  };
}
