let
  mkChromiumAppId = url: "chrome-${url}__-Default";
in
{
  "1" = {
    app_id = [
      "Alacritty"
    ];
  };
  "2" = {
    app_id = [
      "google-chrome"
      "chromium-browser"
    ];
  };
  "3" = {
    app_id = [
      "com.github.johnfactotum.Foliate"
      "org.pwmt.zathura"
    ];
  };
  "4" = {
    app_id = [
      "mpv"
      (mkChromiumAppId "monkeytype.com")
    ];

    title = [
      ".*Opera"
    ];
  };
  "5" = {
    class = [
      "steam"
      "thunderbird"
    ];
  };
  "6" = {
    app_id = [ "Waydroid" ];
    title = [ "Minecraft" ];
  };
  "7" = {
    app_id = [
      "gamescope"
      "discord"
    ];
  };
  "8" = {
    app_id = [
      (mkChromiumAppId "music.youtube.com")
    ];
  };
  "9" = {
    app_id = [
      "org.qbittorrent.qBittorrent"
      "com.obsproject.Studio"
    ];
  };
  "0" = {
    # app_id = [ "" ];
    title = [
      ".*sharing your screen.*"
    ];
  };
}
