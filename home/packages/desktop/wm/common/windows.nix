let
  mkChromiumAppId = url: "chrome-${url}__-Default";
in
{
  "1" = {
    app_id = [
      "Alacritty"
      "footclient"
      "foot"
      "org.wezfurlong.wezterm"
    ];
  };
  "2" = {
    app_id = [
      "firefox"
      "chromium-browser"
      "Brave-browser"
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
  "9" = {
    app_id = [
      "org.qbittorrent.qBittorrent"
      "com.obsproject.Studio"
    ];
  };
  "0" = {
    app_id = [ "" ];
    title = [ "meet.google.com is sharing your screen." ];
  };
}
