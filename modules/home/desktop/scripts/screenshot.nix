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
      mods = [ "super" ];
      key = "F11";
      command = "${screenshot} screen";
    }
    {
      mods = [
        "super"
        "ctrl"
      ];
      key = "F11";
      command = "${screenshot} window";
    }
    {
      mods = [
        "super"
        "shift"
      ];
      key = "F11";
      command = "${screenshot} area";
    }
  ];
}
