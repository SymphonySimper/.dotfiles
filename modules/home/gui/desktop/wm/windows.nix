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
  };
  "5" = {
    class = [
      "steam"
      "thunderbird"
    ];
  };
  "6" = {
    app_id = [
      "gamescope"
      "discord"
    ];
  };
  "8" = {
    title = [ "Spotify" ];
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
    title = [ "meet.google.com is sharing your screen." ];
  };
}
