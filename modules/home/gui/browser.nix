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

  browsers = {
    # refer: https://www.reddit.com/r/NixOS/comments/1cl2kvr/opera_hardware_acceleration_not_working/
    opera = builtins.concatStringsSep " " (
      [
        "LD_LIBRARY_PATH=\"${lib.makeLibraryPath [ pkgs.libGL ]}\""
        (lib.getExe' (pkgs.opera.override { proprietaryCodecs = true; }) "opera")
      ]
      ++ (mkCommandLineArgs {
        ozone = true;
      })
    );

    default = lib.getExe' pkgs.xdg-utils "xdg-open";
  };

  theme = {
    frappe = "olhelnoplefjdmncknfphenjclimckaf";
    latte = "jhjnalhegpceacdhbplhnakmkdliaddd";
    macchiato = "cmpdlhmnmjhihmcfnigoememnffkimlk";
    mocha = "bkkmolkhemgaeaeggcmfbghljjjoofoh";
  };

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

    Entertainment = (
      builtins.concatLists [
        [
          [
            "YouTube"
            "youtube.com"
          ]
          [
            "Netflix"
            "www.netflix.com/browse/my-list"
            browsers.opera
          ]
        ]

        (lib.optionals (my.programs.music == "yt") [
          [
            "YouTube Music"
            "music.youtube.com"
          ]
        ])
      ]
    );

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

  desktopFile = "google-chrome.desktop";
in
{
  config = lib.mkIf my.gui.enable {
    my.desktop = {
      appfolder.Bookmarks = {
        categories = [ category ];
        apps = [ "nixos-manual.desktop" ];
      };

      autostart = [
        "${config.programs.chromium.package}/share/applications/${desktopFile}"
      ];

      automove = [
        [
          desktopFile
          2
        ]
      ];

      mime."google-chrome" = [
        "application/xhtml+xml"
        "text/html"
        "text/xml"
        "x-scheme-handler/ftp"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };

    programs.chromium = {
      enable = true;
      package = pkgs.google-chrome;

      commandLineArgs = mkCommandLineArgs { };

      extensions = [
        theme.${my.theme.flavor} # Catppuccin theme
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      ];
    };

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
  };
}
