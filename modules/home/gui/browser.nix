{
  my,
  pkgs,
  lib,
  ...
}:
let
  theme = {
    frappe = "olhelnoplefjdmncknfphenjclimckaf";
    latte = "jhjnalhegpceacdhbplhnakmkdliaddd";
    macchiato = "cmpdlhmnmjhihmcfnigoememnffkimlk";
    mocha = "bkkmolkhemgaeaeggcmfbghljjjoofoh";
  };

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
      [
        "YouTube Music"
        "music.youtube.com"
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
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;

    commandLineArgs =
      [
        # "--ozone-platform-hint=auto"
      ]
      ++ (builtins.map
        (feature: "--${feature.name}-features=${builtins.concatStringsSep "," feature.value}")
        (
          builtins.filter (f: (builtins.length f.value) > 0) (
            lib.attrsets.mapAttrsToList (name: value: { inherit name value; }) features
          )
        )
      );

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

        scriptName = builtins.concatStringsSep "-" (lib.strings.splitString " " (lib.strings.toLower name));
        execScript = lib.getExe (
          pkgs.writeShellScriptBin scriptName # sh
            ''
              ${lib.getExe' pkgs.xdg-utils "xdg-open"} ${url}                
            ''
        );
      in
      {
        inherit name;
        type = "entry";
        value = {
          inherit name;
          type = "Application";
          genericName = name;
          comment = "Launch ${name}";
          categories = [ "Application" ];
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
