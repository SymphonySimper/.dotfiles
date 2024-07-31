{ userSettings, ... }:
{
  programs.kitty = {
    enable = userSettings.programs.terminal == "kitty";
    font = {
      name = userSettings.font.mono;
      size = 11;
    };
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    settings = {
      eanble_audio_bell = false;
    };
  };
}
