{ userSettings, ... }:
{
  programs.zathura = {
    enable = userSettings.programs.pdf == "zathura";
  };
}
