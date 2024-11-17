{ my, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "wallpaper" ''
      ${pkgs.swaybg}/bin/swaybg -c "${my.theme.color.crust}" -m solid_color;
    '')
  ];
}
