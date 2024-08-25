{ userSettings, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "startup" ''
      brightness -r & # Restore Brightness
      wallpaper &

      if [[ "${userSettings.programs.terminal}" == 'foot' ]]; then
        foot -s &
      fi
    '')
  ];
}
