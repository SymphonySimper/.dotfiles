{ config, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "wallpaper" ''
      ${pkgs.swaybg}/bin/swaybg -c "${config.my.theme.color.crust}" -m solid_color;
    '')
  ];
}
