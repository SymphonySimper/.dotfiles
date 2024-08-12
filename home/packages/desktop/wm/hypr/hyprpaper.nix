{ userSettings, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      preload = [ userSettings.wallpaper ];
      wallpaper = [ ",${userSettings.wallpaper}" ];
    };
  };
}
