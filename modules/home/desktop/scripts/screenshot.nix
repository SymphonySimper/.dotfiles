{ pkgs, lib, ... }:
let
  screenshot = lib.getExe (
    pkgs.writeShellScriptBin "myscreenshot"
      # sh
      ''
        take_screenshot() {
          current_date=$(date +%s)
          ${lib.getExe pkgs.grimblast} --notify --freeze copysave $1 \
          "$HOME/Pictures/Screenshots/$current_date.png"
        }

        take_screenshot "$1"
      ''
  );
in
{
  my.programs.desktop.keybinds = [
    {
      key = "F11";
      cmd = "${screenshot} screen";
    }
    {
      mod = "CTRL";
      key = "F11";
      cmd = "${screenshot} window";
    }
    {
      mod = "SHIFT";
      key = "F11";
      cmd = "${screenshot} area";
    }
  ];
}
