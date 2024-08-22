{ userSettings, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "wallpaper" ''
      ${pkgs.swaybg}/bin/swaybg -c "${userSettings.theme.color.crust}" -m solid_color;
    '')
  ];
}
