{ userSettings, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "startup" ''
      spotify &
      if [[ "${userSettings.programs.terminal}" == 'foot' ]]; then
        foot -s &
      fi

      brightness -r & # Restore Brightness
    '')
  ];
}
