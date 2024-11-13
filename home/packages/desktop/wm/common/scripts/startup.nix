{ userSettings, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "startup" ''
      brightness -r & # Restore Brightness
      ${if userSettings.desktop.name != "sway" then "wallpaper &" else ""}
    '')
  ];
}
