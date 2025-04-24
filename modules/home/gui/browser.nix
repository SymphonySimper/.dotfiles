{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  features = {
    disable = [ "WebRtcAllowInputVolumeAdjustment" ];
    enable = [
      # https://wiki.archlinux.org/title/Chromium#Hardware_video_acceleration
      "AcceleratedVideoDecodeLinuxGL"

      # https://wiki.archlinux.org/title/Chromium#Vulkan
      "VaapiVideoDecoder"
      "VaapiIgnoreDriverChecks"
      "Vulkan"
      "DefaultANGLEVulkan"
      "VulkanFromANGLE"
    ];
  };

  mkCommandLineArgs =
    {
      ozone ? false,
    }:
    builtins.concatLists [
      (lib.optionals ozone [
        "--ozone-platform-hint=auto"
      ])

      (builtins.map (feature: "--${feature.name}-features=${builtins.concatStringsSep "," feature.value}")
        (
          builtins.filter (f: (builtins.length f.value) > 0) (
            lib.attrsets.mapAttrsToList (name: value: { inherit name value; }) features
          )
        )
      )
    ];

  browsers.default = lib.getExe' pkgs.xdg-utils "xdg-open";

  category = "X-MY-Bookmarks";
  bookmarks = {
    "Social Media" = [
      [
        "WhatsApp"
        "web.whatsapp.com"
      ]
      [
        "Discord"
        "discord.com/channels/@me"
      ]
      [
        "Reddit"
        "www.reddit.com"
      ]
    ];

    Email = [
      [
        "Gmail"
        "mail.google.com/mail/u/0/#inbox"
      ]
      [
        "Gmail 1"
        "mail.google.com/mail/u/1/#inbox"
      ]
    ];

    Entertainment = [
      [
        "YouTube"
        "youtube.com"
      ]
    ];

    Anime = [
      [
        "Crunchyroll"
        "crunchyroll.com"
      ]
      [
        "MyAnimeList"
        "myanimelist.net/animelist/SymphonySimper"
      ]
    ];

    Utility = [
      [
        "Excalidraw"
        "excalidraw.com"
      ]
      [
        "Monkeytype"
        "monkeytype.com"
      ]
    ];

    Dev = [
      [
        "Github"
        "github.com"
      ]
    ];
  };

in
{
  config = lib.mkIf my.gui.enable (
    lib.mkMerge [
      # Bookmarks
      {
        xdg.desktopEntries = builtins.listToAttrs (
          builtins.map (
            entry:
            let
              name = builtins.elemAt entry 0;
              _url = builtins.elemAt entry 1;
              url = if lib.strings.hasPrefix "http" _url then _url else "https://${_url}";

              cmd = if builtins.length entry == 2 then browsers.default else builtins.elemAt entry 2;

              scriptName = builtins.concatStringsSep "-" (lib.strings.splitString " " (lib.strings.toLower name));
              execScript = lib.getExe (
                pkgs.writeShellScriptBin scriptName # sh
                  ''
                    ${cmd} ${url}                
                  ''
              );
            in
            {
              inherit name;
              value = {
                inherit name;
                type = "Application";
                genericName = name;
                comment = "Launch ${name}";
                categories = [ category ];
                terminal = false;
                exec = execScript;
                settings = {
                  StartupWMClass = name;
                };
              };
            }
          ) (builtins.concatLists (builtins.attrValues bookmarks))
        );
      }

      # Browsers
      ## Chromium
      {
        programs.chromium = {
          enable = true;
          package = pkgs.google-chrome;

          commandLineArgs = mkCommandLineArgs { };

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
              "nngceckbapebfimnlniiiahkandclblb" # bitwarden
              "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
            ];
        };

        my.desktop = {
          autostart = [ "google-chrome-stable" ];

          mime."google-chrome" = [
            "application/xhtml+xml"
            "text/html"
            "text/xml"
            "x-scheme-handler/ftp"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
          ];

          windows = [
            {
              id = "google-chrome";
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
      }
    ]
  );
}
