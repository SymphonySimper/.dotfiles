{ userSettings, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "startup" ''
      brightness -r & # Restore Brightness
      ${if userSettings.desktop.name != "sway" then "wallpaper &" else ""}
      ${if userSettings.programs.terminal == "foot" then "foot -s &" else ""}
    '')
  ];
}
