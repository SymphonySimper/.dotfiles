let
  mkChromiumAppId = url: "chrome-${url}__-Default";
in
{
  "1".class = [
    "Alacritty"
  ];

  "2".class = [
    "google-chrome"
    "chromium-browser"
  ];

  "3".class = [
    "com.github.johnfactotum.Foliate"
    "org.pwmt.zathura"
  ];

  "4" = {
    class = [
      "mpv"
      (mkChromiumAppId "monkeytype.com")
    ];

    title = [
      ".*Opera"
    ];
  };

  "5".class = [
    "steam"
    "thunderbird"
  ];

  "6" = {
    class = [ "Waydroid" ];
    title = [ "Minecraft" ];
  };

  "7".class = [
    "discord"

    # steam
    "steam_app_.*"
    "gamescope"
  ];

  "8".class = [
    (mkChromiumAppId "music.youtube.com")
  ];

  "9".class = [
    "org.qbittorrent.qBittorrent"
    "com.obsproject.Studio"
  ];

  "0".title = [
    ".*sharing your screen.*"
  ];
}
