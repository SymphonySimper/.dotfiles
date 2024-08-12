{ userSettings, pkgs, ... }:
{

  home.packages = [ pkgs.swayimg ];
  xdg.configFile."swayimg/config" = {
    text = ''
      [general]
      background = ${userSettings.theme.color.base}
      [font]
      size = 24
      name = ${userSettings.font.sans}
      color = ${userSettings.theme.color.text}
      shadow = none
      [keys]
      h = step_left 10
      j = step_down 10
      k = step_up 10
      l = step_right 10

      p = prev_file
      Shift+p = prev_dir
      n = next_file
      Shift+n = next_dir

      f = fullscreen
    '';
  };
}
