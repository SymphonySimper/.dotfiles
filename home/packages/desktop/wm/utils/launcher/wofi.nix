{ userSettings, ... }:
{
  programs.wofi = {
    enable = userSettings.programs.launcher == "wofi";
  };
}
