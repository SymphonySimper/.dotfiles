{ userSettings, ... }:
{
  programs.tofi = {
    enable = userSettings.programs.launcher == "tofi-run";
    settings = {
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 24;
      num-results = 5;
      font = userSettings.font.mono;
      font-size = 16;
    };
  };
}
