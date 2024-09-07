{ config, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "startup" ''
      brightness -r & # Restore Brightness
      wallpaper &

      if [[ "${config.my.program.terminal}" == 'foot' ]]; then
        foot -s &
      fi
    '')
  ];
}
